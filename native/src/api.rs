use crate::db::init::DB_PATH;
use crate::db::model::{
    Gallery, GalleryOrWallpaper, WallPaper, FOLDER_STATE, GLOBAL_GALLERY_ID, JSON_PATH,
};
use crate::storage;
use crate::utils::ScreenParams;
use crate::wallpaper_engine::wallpaper_engine::WallpaperEngine;
use futures::executor::block_on;

pub fn rust_bridge_say_hello() -> String {
    String::from("hello from rust")
}

pub fn init_db() {
    let m = crate::db::init::init_when_first_time_start_with_anyhow();
    match m {
        Ok(_) => {
            println!("初始化数据库成功")
        }
        Err(e) => {
            println!("[rust-init-db-err] : {:?}", e);
            println!("初始化数据库失败")
        }
    }
}

pub fn get_screen_size() -> ScreenParams {
    crate::utils::get_screen_size()
}

pub fn create_all_directory(s: String) {
    storage::create_cache_dir(s.clone());
}

pub fn new_paper(s: String) -> i64 {
    let r = WallPaper::new(s);
    match r {
        Ok(r0) => {
            return r0;
        }
        Err(e) => {
            println!("[rust error new paper] : {:?}", e);
            return -1;
        }
    }
}

#[deprecated = "use `get_all_items` instead"]
pub fn get_all_papers() -> Vec<WallPaper> {
    block_on(async { WallPaper::get_papers() })
}

pub fn get_all_items() -> Vec<GalleryOrWallpaper> {
    Gallery::get_children()
}

pub fn get_paper_by_id(i: i64) -> Option<WallPaper> {
    block_on(async { WallPaper::get_paper_by_id(i) })
}

pub fn delete_paper_by_id(i: i64) -> i64 {
    let r = WallPaper::delete_paper_by_id(i);
    match r {
        Ok(_) => {
            return 0;
        }
        Err(e) => {
            println!("[rust-delete-file-error]:{:?}", e);
            return -1;
        }
    }
}

pub fn set_is_fav_by_id(i: i64, is_fav: i64) -> i64 {
    block_on(async { WallPaper::set_fav_by_id(i, is_fav) })
}

pub fn get_all_favs() -> Vec<WallPaper> {
    block_on(async { WallPaper::get_all_favs() })
}

pub fn get_current_wall_paper() -> String {
    let f = wallpaper::get();
    match f {
        Ok(f0) => {
            return f0;
        }
        Err(_) => {
            return String::new();
        }
    }
}

pub fn set_wall_paper(s: String) -> i64 {
    WallpaperEngine::set_wallpaper(s)
}

// 设置 json 路径
pub fn set_json_path(s: String) {
    if !crate::db::init::path_exists(s.clone()) {
        let _ = std::fs::File::create(s.clone());
    }
    let mut _s = JSON_PATH.lock().unwrap();
    *_s = s;
}

// 设置 db 路径
pub fn set_db_path(s: String) {
    let mut _s = DB_PATH.lock().unwrap();
    *_s = s;
}

// 修改当前 gallery_id
pub fn set_gallery_id(id: i64) {
    let mut _s = GLOBAL_GALLERY_ID.lock().unwrap();
    *_s = id;
}

// 新建 gallery
pub fn create_new_gallery(s: String) -> i64 {
    Gallery::new_gallery(s)
}

// 获取当前parent_id
pub fn get_parent_id() -> i64 {
    block_on(async { crate::db::model::get_parent_id().await })
}

// 删除 gallery
pub fn delete_gallery_directly_by_id(i: i64) {
    let r = Gallery::delete_gallery_by_id_directly(i);
    match r {
        Ok(_) => {}
        Err(e) => {
            println!("[rust-delete-folder-error] : {:?}", e);
        }
    }
}

// 删除 gallery
pub fn delete_gallery_keep_children_by_id(i: i64) {
    let r = Gallery::delete_gallery_by_id_keep_children(i);
    match r {
        Ok(_) => {}
        Err(e) => {
            println!("[rust-delete-folder-error] : {:?}", e);
        }
    }
}

pub fn download_file(url: String, save_path: String) -> String {
    match crate::utils::download_file(url, save_path) {
        Ok(o) => {
            return o;
        }
        Err(e) => {
            println!("[rust-download-error]:{:?}", e);
            return String::new();
        }
    }
}

pub fn get_children_by_id(i: i64) -> Vec<GalleryOrWallpaper> {
    let rt = tokio::runtime::Runtime::new().unwrap();
    rt.block_on(async {
        let folder = &*FOLDER_STATE.lock().unwrap();
        let folder_or_files = folder.get_children(i);
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

// 移动
pub fn move_item(to_id: i64, f: GalleryOrWallpaper) {
    Gallery::move_item(to_id, f)
}

// 设置视频壁纸
pub fn set_dynamic_wallpaper(pid: u32) {
    let r = WallpaperEngine::set_dynamic_wallpaper(pid);
    match r {
        Ok(_) => {}
        Err(e) => {
            println!("[rust-wallpaper-error]: {:?}", e)
        }
    }
}
