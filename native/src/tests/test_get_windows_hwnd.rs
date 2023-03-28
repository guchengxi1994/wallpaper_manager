
#[test]
fn get_windows_hwnd_2() {
    let desktop_handle = unsafe { winapi::um::winuser::GetDesktopWindow() };
    println!("Desktop handle: {:?}", desktop_handle);
    let _f = format!("{:?}",desktop_handle);
    let number = i64::from_str_radix("002900bc", 16);
    println!("{:?}",number)
}