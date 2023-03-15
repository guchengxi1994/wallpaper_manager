use crate::db::model::WallPaper;
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
        Err(_) => {
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

pub fn get_all_papers() -> Vec<WallPaper> {
    block_on(async { WallPaper::get_papers() })
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
