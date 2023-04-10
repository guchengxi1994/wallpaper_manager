use super::*;
// Section: wire functions

#[wasm_bindgen]
pub fn wire_rust_bridge_say_hello(port_: MessagePort) {
    wire_rust_bridge_say_hello_impl(port_)
}

#[wasm_bindgen]
pub fn wire_init_db(port_: MessagePort) {
    wire_init_db_impl(port_)
}

#[wasm_bindgen]
pub fn wire_get_screen_size(port_: MessagePort) {
    wire_get_screen_size_impl(port_)
}

#[wasm_bindgen]
pub fn wire_create_all_directory(port_: MessagePort, s: String) {
    wire_create_all_directory_impl(port_, s)
}

#[wasm_bindgen]
pub fn wire_new_paper(port_: MessagePort, s: String) {
    wire_new_paper_impl(port_, s)
}

#[wasm_bindgen]
pub fn wire_get_all_papers(port_: MessagePort) {
    wire_get_all_papers_impl(port_)
}

#[wasm_bindgen]
pub fn wire_get_all_items(port_: MessagePort) {
    wire_get_all_items_impl(port_)
}

#[wasm_bindgen]
pub fn wire_get_paper_by_id(port_: MessagePort, i: i64) {
    wire_get_paper_by_id_impl(port_, i)
}

#[wasm_bindgen]
pub fn wire_delete_paper_by_id(port_: MessagePort, i: i64) {
    wire_delete_paper_by_id_impl(port_, i)
}

#[wasm_bindgen]
pub fn wire_set_is_fav_by_id(port_: MessagePort, i: i64, is_fav: i64) {
    wire_set_is_fav_by_id_impl(port_, i, is_fav)
}

#[wasm_bindgen]
pub fn wire_get_all_favs(port_: MessagePort) {
    wire_get_all_favs_impl(port_)
}

#[wasm_bindgen]
pub fn wire_get_current_wall_paper(port_: MessagePort) {
    wire_get_current_wall_paper_impl(port_)
}

#[wasm_bindgen]
pub fn wire_set_wall_paper(port_: MessagePort, s: String) {
    wire_set_wall_paper_impl(port_, s)
}

#[wasm_bindgen]
pub fn wire_set_json_path(port_: MessagePort, s: String) {
    wire_set_json_path_impl(port_, s)
}

#[wasm_bindgen]
pub fn wire_set_db_path(port_: MessagePort, s: String) {
    wire_set_db_path_impl(port_, s)
}

#[wasm_bindgen]
pub fn wire_set_gallery_id(port_: MessagePort, id: i64) {
    wire_set_gallery_id_impl(port_, id)
}

#[wasm_bindgen]
pub fn wire_create_new_gallery(port_: MessagePort, s: String) {
    wire_create_new_gallery_impl(port_, s)
}

#[wasm_bindgen]
pub fn wire_get_parent_id(port_: MessagePort) {
    wire_get_parent_id_impl(port_)
}

#[wasm_bindgen]
pub fn wire_delete_gallery_directly_by_id(port_: MessagePort, i: i64) {
    wire_delete_gallery_directly_by_id_impl(port_, i)
}

#[wasm_bindgen]
pub fn wire_delete_gallery_keep_children_by_id(port_: MessagePort, i: i64) {
    wire_delete_gallery_keep_children_by_id_impl(port_, i)
}

#[wasm_bindgen]
pub fn wire_download_file(port_: MessagePort, url: String, save_path: String) {
    wire_download_file_impl(port_, url, save_path)
}

#[wasm_bindgen]
pub fn wire_get_children_by_id(port_: MessagePort, i: i64) {
    wire_get_children_by_id_impl(port_, i)
}

#[wasm_bindgen]
pub fn wire_move_item(port_: MessagePort, to_id: i64, f: JsValue) {
    wire_move_item_impl(port_, to_id, f)
}

#[wasm_bindgen]
pub fn wire_set_dynamic_wallpaper(port_: MessagePort, pid: u32) {
    wire_set_dynamic_wallpaper_impl(port_, pid)
}

// Section: allocate functions

// Section: related functions

// Section: impl Wire2Api

impl Wire2Api<String> for String {
    fn wire2api(self) -> String {
        self
    }
}

impl Wire2Api<Gallery> for JsValue {
    fn wire2api(self) -> Gallery {
        let self_ = self.dyn_into::<JsArray>().unwrap();
        assert_eq!(
            self_.length(),
            4,
            "Expected 4 elements, got {}",
            self_.length()
        );
        Gallery {
            gallery_id: self_.get(0).wire2api(),
            create_at: self_.get(1).wire2api(),
            is_deleted: self_.get(2).wire2api(),
            gallery_name: self_.get(3).wire2api(),
        }
    }
}
impl Wire2Api<GalleryOrWallpaper> for JsValue {
    fn wire2api(self) -> GalleryOrWallpaper {
        let self_ = self.unchecked_into::<JsArray>();
        match self_.get(0).unchecked_into_f64() as _ {
            0 => GalleryOrWallpaper::Gallery(self_.get(1).wire2api()),
            1 => GalleryOrWallpaper::WallPaper(self_.get(1).wire2api()),
            _ => unreachable!(),
        }
    }
}

impl Wire2Api<Vec<u8>> for Box<[u8]> {
    fn wire2api(self) -> Vec<u8> {
        self.into_vec()
    }
}
impl Wire2Api<WallPaper> for JsValue {
    fn wire2api(self) -> WallPaper {
        let self_ = self.dyn_into::<JsArray>().unwrap();
        assert_eq!(
            self_.length(),
            6,
            "Expected 6 elements, got {}",
            self_.length()
        );
        WallPaper {
            wall_paper_id: self_.get(0).wire2api(),
            file_path: self_.get(1).wire2api(),
            file_hash: self_.get(2).wire2api(),
            create_at: self_.get(3).wire2api(),
            is_deleted: self_.get(4).wire2api(),
            is_fav: self_.get(5).wire2api(),
        }
    }
}
// Section: impl Wire2Api for JsValue

impl Wire2Api<String> for JsValue {
    fn wire2api(self) -> String {
        self.as_string().expect("non-UTF-8 string, or not a string")
    }
}
impl Wire2Api<i64> for JsValue {
    fn wire2api(self) -> i64 {
        ::std::convert::TryInto::try_into(self.dyn_into::<js_sys::BigInt>().unwrap()).unwrap()
    }
}
impl Wire2Api<u32> for JsValue {
    fn wire2api(self) -> u32 {
        self.unchecked_into_f64() as _
    }
}
impl Wire2Api<u8> for JsValue {
    fn wire2api(self) -> u8 {
        self.unchecked_into_f64() as _
    }
}
impl Wire2Api<Vec<u8>> for JsValue {
    fn wire2api(self) -> Vec<u8> {
        self.unchecked_into::<js_sys::Uint8Array>().to_vec().into()
    }
}
