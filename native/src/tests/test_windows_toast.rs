#[allow(unused_imports)]
use winrt_notification::{Duration, Sound, Toast};

#[test]
fn test_toast(){
    Toast::new(Toast::POWERSHELL_APP_ID)
        .title("Look at this flip!")
        .text1("(╯°□°）╯︵ ┻━┻")
        .sound(Some(Sound::SMS))
        .duration(Duration::Short)
        .show()
        .expect("unable to toast");
}