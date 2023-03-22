use lazy_static::lazy_static;
use std::{fs::File, path::Path, sync::Mutex};
use tokio::runtime::Runtime;

use super::connection::{MyPool, POOL};

lazy_static! {
    pub static ref DB_PATH: Mutex<String> = Mutex::new(String::new());
}

const CREATE_WALL_PAPERS_DB: &str = "CREATE TABLE IF NOT EXISTS wall_paper (
    wall_paper_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    file_path TEXT,
    file_hash TEXT,
    create_at integer,
    is_deleted integer DEFAULT 0,
    is_fav integer DEFAULT 0
)";

const CREATE_GALLERY_DB: &str = "CREATE TABLE IF NOT EXISTS gallery (
    gallery_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    gallery_name TEXT,
    create_at integer,
    is_deleted integer DEFAULT 0
)";

pub fn path_exists(p: String) -> bool {
    Path::new(&p).exists()
}

pub fn init_when_first_time_start_with_anyhow() -> anyhow::Result<()> {
    let rt = Runtime::new().unwrap();
    rt.block_on(async {
        let db_path = (*DB_PATH.lock().unwrap()).clone();
        // let url = format!("sqlite:{:?}",db_path.as_str());
        let url = String::from("sqlite:") + &db_path;
        println!("{:?}",url);

        if path_exists(db_path.clone()) {
            let pool = POOL.clone();
            let mut pool = pool.write().await;
            *pool = MyPool::new(&url).await;
            return anyhow::Ok(());
        }
        let _ = File::create(db_path)?;
        let pool = POOL.clone();
        let mut pool = pool.write().await;
        *pool = MyPool::new(&url).await;
        let _ = sqlx::query(CREATE_WALL_PAPERS_DB)
            .execute(pool.get_pool())
            .await?;
        let _ = sqlx::query(CREATE_GALLERY_DB)
            .execute(pool.get_pool())
            .await?;

        anyhow::Ok(())
    })
}
