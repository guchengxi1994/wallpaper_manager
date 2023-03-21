use crate::db::model::{Gallery, GalleryOrWallpaper, WallPaper, GLOBAL_GALLERY_ID, JSON_PATH};
use crate::storage;
use crate::utils::ScreenParams;
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
            println!("[rust error] : {:?}", e);
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
    block_on(async { WallPaper::delete_paper_by_id(i) })
}

pub fn set_is_fav_by_id(i: i64, is_fav: i64) -> i64 {
    block_on(async { WallPaper::set_fav_by_id(i, is_fav) })
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
    let r = wallpaper::set_from_path(s.as_str());
    match r {
        Ok(_) => {
            return 0;
        }
        Err(_) => {
            return -1;
        }
    }
}

// 设置 json 路径
pub fn set_json_path(s: String) {
    block_on(async {
        if !crate::db::init::path_exists(s.clone()) {
            let _ = std::fs::File::create(s.clone());
        }
        let mut _s = JSON_PATH.lock().await;
        *_s = s;
    })
}

// 修改当前 gallery_id
pub fn set_gallery_id(id: i64) {
    block_on(async {
        let mut _s = GLOBAL_GALLERY_ID.lock().await;
        *_s = id;
    })
}

// 新建 gallery
pub fn create_new_gallery(s: String) -> i64 {
    Gallery::new_gallery(s)
}

// 获取当前parent_id
pub fn get_parent_id() -> i64 {
    block_on(async { crate::db::model::get_parent_id().await })
}
