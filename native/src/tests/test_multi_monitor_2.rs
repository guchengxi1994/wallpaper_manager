use winsafe::prelude::*;
use winsafe::HWND;
use winsafe::{co, EnumDisplayDevices, DISPLAY_DEVICE};
use winsafe::{HDC, HMONITOR, RECT};

#[test]
fn test_2() -> anyhow::Result<()> {
    let hdc: HDC = HDC::NULL;
    hdc.EnumDisplayMonitors(None, |hmon: HMONITOR, _hdc: HDC, rc: &RECT| -> bool {
        println!("HMONITOR: {}, ", hmon);
        println!("HMONITOR RECT: {}, ", rc);
        println!("HMONITOR hdc: {}, ", _hdc);
        let w = _hdc.WindowFromDC();
        match w {
            Some(w0) => {
                println!("HMONITOR window: {}, ", w0);
            }
            None => {
                println!("error");
            }
        }

        println!("======================= ");
        true
    })?;

    anyhow::Ok(())
}

#[test]
fn test_3() {
    let hwnd = HWND::GetDesktopWindow();
    let pwnd = hwnd.GetWindow(co::GW::CHILD);
    match pwnd {
        Ok(p) => {
            println!("{:?}", p)
        }
        Err(e) => {
            println!("{:?}", e)
        }
    }
}

#[test]
fn test_4() {
    let hwnd = HWND::NULL;
    hwnd.EnumChildWindows(|hchild: HWND| -> bool {
        println!("Child HWND: {}", hchild);
        true
    });
}
