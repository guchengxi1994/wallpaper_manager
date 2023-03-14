use crypto::{digest::Digest, md5::Md5};
use std::{
    fs,
    time::{SystemTime, UNIX_EPOCH},
};
use tokio::runtime::Runtime;

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
            let pool = crate::db::connection::POOL.read().await;
            let _h = get_hash_from_last_edit(file_path.clone());
            let _count: (i64,) = sqlx::query_as(
                r#"SELECT COUNT(1) from wall_paper WHERE file_hash = ? and is_deleted = 0"#,
            )
            .bind(_h.clone())
            .fetch_one(pool.get_pool())
            .await?;
            if _count.0 > 0 {
                return anyhow::Ok(1);
            }

            let _sql = sqlx::query(
                r#"INSERT INTO wall_paper (file_path,file_hash,create_at) VALUES (?,?,?)"#,
            )
            .bind(file_path)
            .bind(_h)
            .bind(_t as i64)
            .execute(pool.get_pool())
            .await?;

            anyhow::Ok(_sql.last_insert_rowid())
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

    #[tokio::main]
    pub async fn delete_paper_by_id(i: i64) -> i64 {
        let pool = crate::db::connection::POOL.read().await;
        let _sql = sqlx::query(r#"UPDATE wall_paper SET is_deleted = 1 where wall_paper_id = ?"#)
            .bind(i)
            .execute(pool.get_pool())
            .await;
        match _sql {
            Ok(_) => {
                return 0;
            }
            Err(e) => {
                println!("[rust delete image error]: {:?}", e);
                return -1;
            }
        }
    }

    #[tokio::main]
    pub async fn set_fav_by_id(i: i64, is_fav: i64) -> i64 {
        let pool = crate::db::connection::POOL.read().await;
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
