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
