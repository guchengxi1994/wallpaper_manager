use crypto::{digest::Digest, md5::Md5};
use futures::executor::block_on;
use lazy_static::lazy_static;
use rs_filemanager::model::folder::Folder;
use sqlx::{Pool, Sqlite};
use std::{
    fs,
    sync::Mutex,
    time::{SystemTime, UNIX_EPOCH},
};
use tokio::runtime::Runtime;

lazy_static! {
    pub static ref JSON_PATH: Mutex<String> = Mutex::new(String::new());
    pub static ref FOLDER_STATE: Mutex<Folder> = {
        let folder = Folder::default_with_save_path(
            block_on(async { JSON_PATH.lock().unwrap() }).to_string(),
        );
        Mutex::new(folder)
    };
    pub static ref GLOBAL_GALLERY_ID: Mutex<i64> = {
        let gallery_id = 0;
        Mutex::new(gallery_id)
    };
}

pub async fn get_parent_id() -> i64 {
    let current_folder_id = *GLOBAL_GALLERY_ID.lock().unwrap();
    let folder = &*FOLDER_STATE.lock().unwrap();

    return folder.get_parent_id(current_folder_id);
}

#[derive(Clone, Debug, sqlx::FromRow)]
pub struct WallPaper {
    pub wall_paper_id: i64,
    pub file_path: String,
    pub file_hash: String,
    pub create_at: i64,
    pub is_deleted: i64,
    pub is_fav: i64,
}

impl WallPaper {
    pub fn new(file_path: String) -> anyhow::Result<i64> {
        let rt = Runtime::new().unwrap();
        rt.block_on(async {
            let _t = SystemTime::now()
                .duration_since(UNIX_EPOCH)
                .unwrap()
                .as_secs();
            let _h = get_hash_from_last_edit(file_path.clone());
            println!("[rust ] here is going to get pool");
            let pool = crate::db::connection::POOL.read().await;
            let _p = pool.get_pool();

            // let pool = sqlx::sqlite::SqlitePoolOptions::new().max_connections(10).connect("sqlite:D:/github_repo/wallpaper_manager/data.db").await?;

            println!("[rust ] here get pool");
            {
                let _count: (i64,) = sqlx::query_as(
                    r#"SELECT COUNT(1) from wall_paper WHERE file_hash = ? and is_deleted = 0"#,
                )
                .bind(_h.clone())
                .fetch_one(_p)
                .await?;
                if _count.0 > 0 {
                    return anyhow::Ok(0);
                }

                println!("[rust ] get count done");
            }

            {
                let _sql = sqlx::query(
                    r#"INSERT INTO wall_paper (file_path,file_hash,create_at) VALUES (?,?,?)"#,
                )
                .bind(file_path.clone())
                .bind(_h)
                .bind(_t as i64)
                .execute(_p)
                .await?;

                println!("[rust ] insert done");

                let current_folder_id = *GLOBAL_GALLERY_ID.lock().unwrap();

                FOLDER_STATE.lock().unwrap().add_a_file_to_current_folder(
                    current_folder_id,
                    rs_filemanager::model::file::File {
                        path: file_path.clone(),
                        parent_id: current_folder_id,
                        file_id: _sql.last_insert_rowid(),
                    },
                );

                FOLDER_STATE
                    .lock()
                    .unwrap()
                    .to_file(JSON_PATH.lock().unwrap().to_string());
                anyhow::Ok(_sql.last_insert_rowid())
            }
        })
    }

    #[tokio::main]
    pub async fn get_paper_by_id(i: i64) -> Option<WallPaper> {
        let pool = crate::db::connection::POOL.read().await;
        let _sql = sqlx::query_as::<sqlx::Sqlite, WallPaper>(
            r#"SELECT * from wall_paper where is_deleted = 0 and wall_paper_id = ?"#,
        )
        .bind(i)
        .fetch_one(pool.get_pool())
        .await;

        match _sql {
            Ok(s) => {
                return Some(s);
            }
            Err(_) => None,
        }
    }

    pub fn delete_paper_by_id(i: i64) -> anyhow::Result<()> {
        let rt = tokio::runtime::Runtime::new().unwrap();
        rt.block_on(async {
            let pool = crate::db::connection::POOL.write().await;
            let _ = sqlx::query(r#"UPDATE wall_paper SET is_deleted = 1 where wall_paper_id = ?"#)
                .bind(i)
                .execute(pool.get_pool())
                .await?;
            // match _sql {
            //     Ok(_) => {
            //         return  0;
            //     }
            //     Err(e) => {
            //         println!("[rust delete image error]: {:?}", e);
            //         return -1;
            //     }
            // }
            let current_folder_id = *GLOBAL_GALLERY_ID.lock().unwrap();

            println!("[rust-should-be-deleted-id] {:?}", i);

            // Folder::add_a_folder_to_current_folder();
            FOLDER_STATE
                .lock()
                .unwrap()
                .remove_a_file_from_current_folder(
                    current_folder_id,
                    rs_filemanager::model::file::File {
                        path: String::from(""),
                        parent_id: current_folder_id,
                        file_id: i,
                    },
                );
            FOLDER_STATE
                .lock()
                .unwrap()
                .to_file(JSON_PATH.lock().unwrap().to_string());

            anyhow::Ok(())
        })
    }

    #[tokio::main]
    pub async fn set_fav_by_id(i: i64, is_fav: i64) -> i64 {
        let pool = crate::db::connection::POOL.write().await;
        let _sql = sqlx::query(r#"UPDATE wall_paper SET is_fav = ? where wall_paper_id = ?"#)
            .bind(is_fav)
            .bind(i)
            .execute(pool.get_pool())
            .await;

        match _sql {
            Ok(_) => {
                return 0;
            }
            Err(e) => {
                println!("[rust modify is_fav error]: {:?}", e);
                return -1;
            }
        }
    }

    #[tokio::main]
    pub async fn get_papers() -> Vec<WallPaper> {
        let pool = crate::db::connection::POOL.read().await;
        let _sql = sqlx::query_as::<sqlx::Sqlite, WallPaper>(
            r#"SELECT * from wall_paper where is_deleted = 0"#,
        )
        .fetch_all(pool.get_pool())
        .await;

        match _sql {
            Ok(s) => {
                return s;
            }
            Err(_) => {
                vec![]
            }
        }
    }

    pub async fn from_file(
        f: rs_filemanager::model::file::File,
        pool: &Pool<Sqlite>,
    ) -> Option<WallPaper> {
        // let pool = crate::db::connection::POOL.read().await;
        let _sql = sqlx::query_as::<sqlx::Sqlite, WallPaper>(
            r#"SELECT * from wall_paper where is_deleted = 0 and wall_paper_id = ?"#,
        )
        .bind(f.file_id)
        .fetch_one(pool)
        .await;

        match _sql {
            Ok(s) => {
                return Some(s);
            }
            Err(e) => {
                println!("[rust-error-paper]:{:?}", e);
                return None;
            }
        }
    }
}

pub fn get_last_edit(p: String) -> u64 {
    let metadata = fs::metadata(p);
    match metadata {
        Ok(m) => {
            let modified = m.modified().unwrap_or(SystemTime::now());
            modified.duration_since(UNIX_EPOCH).unwrap().as_secs()
        }
        Err(_) => SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .unwrap()
            .as_secs(),
    }
}

pub fn get_hash_from_last_edit(p: String) -> String {
    let r = get_last_edit(p.clone()).to_string();
    let mut hasher = Md5::new();
    r.to_string().push_str(&p);
    hasher.input_str(&r);
    return hasher.result_str();
}

#[derive(Clone, Debug, sqlx::FromRow)]
pub struct Gallery {
    pub gallery_id: i64,
    pub create_at: i64,
    pub is_deleted: i64,
    pub gallery_name: String,
}

pub enum GalleryOrWallpaper {
    Gallery(Gallery),
    WallPaper(WallPaper),
}

impl Gallery {
    /// 直接删除，不保留子文件数据
    pub fn delete_gallery_by_id_directly(i: i64) -> anyhow::Result<()> {
        let rt = tokio::runtime::Runtime::new().unwrap();
        rt.block_on(async {
            let pool = crate::db::connection::POOL.write().await;
            let _ = sqlx::query(r#"UPDATE gallery SET is_deleted = 1 where gallery_id = ?"#)
                .bind(i)
                .execute(pool.get_pool())
                .await?;
            let current_folder_id = *GLOBAL_GALLERY_ID.lock().unwrap();

            println!("[rust-folder-should-be-deleted-id] {:?}", i);

            let children = FOLDER_STATE.lock().unwrap().get_children(i);

            // Folder::add_a_folder_to_current_folder();
            FOLDER_STATE
                .lock()
                .unwrap()
                .remove_a_folder_from_current_folder_directly(
                    current_folder_id,
                    rs_filemanager::model::folder::Folder {
                        children,
                        name: String::new(),
                        parent_id: Some(current_folder_id),
                        folder_id: i,
                    },
                );
            FOLDER_STATE
                .lock()
                .unwrap()
                .to_file(JSON_PATH.lock().unwrap().to_string());

            anyhow::Ok(())
        })
    }

    /// 删除，保留子文件数据
    pub fn delete_gallery_by_id_keep_children(i: i64) -> anyhow::Result<()> {
        let rt = tokio::runtime::Runtime::new().unwrap();
        rt.block_on(async {
            let pool = crate::db::connection::POOL.write().await;
            let _ = sqlx::query(r#"UPDATE gallery SET is_deleted = 1 where gallery_id = ?"#)
                .bind(i)
                .execute(pool.get_pool())
                .await?;
            let current_folder_id = *GLOBAL_GALLERY_ID.lock().unwrap();

            println!("[rust-folder-should-be-deleted-id] {:?}", i);

            let children = FOLDER_STATE.lock().unwrap().get_children(i);

            // Folder::add_a_folder_to_current_folder();
            FOLDER_STATE
                .lock()
                .unwrap()
                .remove_a_folder_from_current_folder_keep_children(
                    current_folder_id,
                    rs_filemanager::model::folder::Folder {
                        children,
                        name: String::new(),
                        parent_id: Some(current_folder_id),
                        folder_id: i,
                    },
                );
            FOLDER_STATE
                .lock()
                .unwrap()
                .to_file(JSON_PATH.lock().unwrap().to_string());

            anyhow::Ok(())
        })
    }

    pub async fn from_folder(folder: Folder, pool: &Pool<Sqlite>) -> Option<Gallery> {
        // let pool = crate::db::connection::POOL.read().await;
        let _sql = sqlx::query_as::<sqlx::Sqlite, Gallery>(
            r#"SELECT * from gallery where is_deleted = 0 and Gallery_id = ?"#,
        )
        .bind(folder.folder_id)
        .fetch_one(pool)
        .await;

        match _sql {
            Ok(s) => {
                // println!("{:?}",s.Gallery_id);
                return Some(s);
            }
            Err(e) => {
                println!("[rust-error-gallery]:{:?}", e);
                return None;
            }
        }
    }

    #[tokio::main]
    pub async fn new_gallery(name: String) -> i64 {
        let pool = crate::db::connection::POOL.write().await;
        let _t = SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .unwrap()
            .as_secs();
        let _sql = sqlx::query(r#"INSERT INTO gallery (Gallery_name,create_at) VALUES (?,?)"#)
            .bind(name.clone())
            .bind(_t as i64)
            .execute(pool.get_pool())
            .await;

        match _sql {
            Ok(s) => {
                let current_folder_id = *GLOBAL_GALLERY_ID.lock().unwrap();

                // Folder::add_a_folder_to_current_folder();
                FOLDER_STATE.lock().unwrap().add_a_folder_to_current_folder(
                    current_folder_id,
                    Folder {
                        children: vec![],
                        folder_id: s.last_insert_rowid(),
                        name,
                        parent_id: Some(current_folder_id),
                    },
                );
                FOLDER_STATE
                    .lock()
                    .unwrap()
                    .to_file(JSON_PATH.lock().unwrap().to_string());
                return s.last_insert_rowid();
            }
            Err(e) => {
                println!("[rust-new-Gallery-err] : {:?}", e);
                return 0;
            }
        }
    }

    pub fn get_children() -> Vec<GalleryOrWallpaper> {
        let rt = tokio::runtime::Runtime::new().unwrap();
        rt.block_on(async {
            let folder = FOLDER_STATE.lock().unwrap();
            let folder_or_files = folder.get_children(*GLOBAL_GALLERY_ID.lock().unwrap());
            println!("[rust-vec-length] : {:?}", folder_or_files.len());
            let mut res: Vec<GalleryOrWallpaper> = Vec::new();

            let pool = crate::db::connection::POOL.read().await;
            let _p = pool.get_pool();

            for i in folder_or_files {
                match i {
                    rs_filemanager::model::folder::FileOrFolder::File(file) => {
                        match WallPaper::from_file(file, _p).await {
                            Some(w) => {
                                res.push(GalleryOrWallpaper::WallPaper(w));
                            }
                            None => {}
                        }
                    }
                    rs_filemanager::model::folder::FileOrFolder::Folder(folder) => {
                        match Gallery::from_folder(folder, _p).await {
                            Some(w) => {
                                res.push(GalleryOrWallpaper::Gallery(w));
                            }
                            None => {}
                        }
                    }
                }
            }
            res
        })
    }
}
