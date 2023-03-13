#[allow(unused_imports)]
use wallpaper;

#[test]
fn change_wallpager_test() {
    // Returns the wallpaper of the current desktop.
    println!("{:?}", wallpaper::get());
    // Sets the wallpaper for the current desktop from a file path.
    wallpaper::set_from_path(r"C:\Users\xiaoshuyui\Desktop\我的图片.png").unwrap();
    // Sets the wallpaper style.
    wallpaper::set_mode(wallpaper::Mode::Crop).unwrap();
    // Returns the wallpaper of the current desktop.
    println!("{:?}", wallpaper::get());
}