use std::{fs, path::Path};

const CACHE_FOLDER_NAME: &str = "cache";

pub fn create_cache_dir(base_path: String) -> i32 {
    let exists = Path::new(&(base_path.clone() + "/" + CACHE_FOLDER_NAME)).exists();
    if exists {
        return 0;
    }

    let result = fs::create_dir(base_path + "/" + CACHE_FOLDER_NAME);
    match result {
        Ok(_) => 0,
        Err(_) => 1,
    }
}
