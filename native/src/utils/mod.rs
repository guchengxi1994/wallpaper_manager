use std::fs::File;

use winapi::um::winuser::{GetSystemMetrics, SM_CXSCREEN, SM_CYSCREEN};

pub struct ScreenParams {
    pub width: i32,
    pub height: i32,
}

impl ScreenParams {
    pub fn default() -> Self {
        ScreenParams {
            width: 0,
            height: 0,
        }
    }
}

pub fn get_screen_size() -> ScreenParams {
    if cfg!(target_os = "windows") {
        let width = unsafe { GetSystemMetrics(SM_CXSCREEN) };
        let height = unsafe { GetSystemMetrics(SM_CYSCREEN) };
        return ScreenParams { width, height };
    } else {
        return ScreenParams::default();
    }
}

pub fn download_file(url: String, save_path: String) -> anyhow::Result<String> {
    let rt = tokio::runtime::Runtime::new().unwrap();
    rt.block_on(async {
        let resp = reqwest::get(url).await?;

        let fpath;
        let mut dest = {
            let fname = resp
                .url()
                .path_segments()
                .and_then(|segments| segments.last())
                .and_then(|name| if name.is_empty() { None } else { Some(name) })
                .unwrap_or("tmp.bin");
            fpath = save_path + "/" + fname;
            File::create(fpath.clone())?
        };

        let rname = fpath;

        std::io::copy(&mut resp.bytes().await?.to_vec().as_slice(), &mut dest)?;
        return anyhow::Ok(rname);
    })
}
