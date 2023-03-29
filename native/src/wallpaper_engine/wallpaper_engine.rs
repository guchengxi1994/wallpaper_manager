use std::cell::RefCell;

use winsafe::{
    co::{self, WS},
    msg::WndMsg,
    prelude::{user_Hwnd, Handle},
    AtomStr, EnumWindows, HWND, WINDOWINFO,
};


pub struct WallpaperEngine;

impl WallpaperEngine {
    // 根据pid 获取句柄
    pub fn find_window_handle(pid: u32) -> HWND {
        let res: RefCell<HWND> = RefCell::new(HWND::NULL);
        EnumWindows(|hwnd: HWND| -> bool {
            let text = hwnd.GetWindowText().unwrap();
            let mut info = WINDOWINFO::default();
            hwnd.GetWindowInfo(&mut info).unwrap();

            if !text.is_empty() && (info.dwStyle & WS::VISIBLE != WS::NoValue) {
                let (_, _pid) = hwnd.GetWindowThreadProcessId();
                println!("title:{},_pid:{},hwnd:{}", text, _pid, hwnd);
                if pid == _pid {
                    *res.borrow_mut() = hwnd;
                }
            }
            true
        })
        .unwrap();

        res.into_inner()
    }

    // 获取桌面句柄
    pub fn get_worker_w() -> HWND {
        let result = RefCell::new(HWND::NULL);
        let progman =
            HWND::FindWindow(Some(AtomStr::from_str("Progman")), None).unwrap_or(HWND::NULL);
        if progman != HWND::NULL {
            progman
                .SendMessageTimeout(
                    WndMsg {
                        msg_id: 0x052C.into(),
                        wparam: 0xD,
                        lparam: 0x1,
                    },
                    co::SMTO::NORMAL,
                    1000,
                )
                .unwrap_or_default();
        }

        EnumWindows(|top_handle: HWND| -> bool {
            let shell_dll_def_view =
                top_handle.FindWindowEx(None, AtomStr::from_str("SHELLDLL_DefView"), None);

            match shell_dll_def_view {
                Ok(shell_dll_def_view) => {
                    if shell_dll_def_view == HWND::NULL {
                        return true;
                    }

                    let class_name = top_handle.GetClassName().unwrap_or_default();
                    if class_name != "WorkerW" {
                        return true;
                    }

                    let tmp = HWND::NULL
                        .FindWindowEx(Some(&top_handle), AtomStr::from_str("WorkerW"), None)
                        .unwrap_or(HWND::NULL);

                    result.replace(tmp);
                    return true;
                }
                Err(_) => {
                    return true;
                }
            };
        })
        .unwrap_or_default();

        result.into_inner()
    }

    pub fn set_dynamic_wallpaper(pid: u32) -> anyhow::Result<()> {
        if cfg!(windows) {
            let _h = Self::find_window_handle(pid);
            if _h == HWND::NULL {
                return anyhow::Ok(());
            }
            let worker_w = Self::get_worker_w();
            if worker_w == HWND::NULL {
                return Ok(());
            }
            _h.SetParent(&worker_w)?;
        } else {
            todo!()
        }

        anyhow::Ok(())
    }

    pub fn set_wallpaper(img_path: String) -> i64 {
        let r = wallpaper::set_from_path(img_path.as_str());
        match r {
            Ok(_) => {
                return 0;
            }
            Err(_) => {
                return -1;
            }
        }
    }
}
