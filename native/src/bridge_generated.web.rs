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

// Section: allocate functions

// Section: related functions

// Section: impl Wire2Api

impl Wire2Api<String> for String {
    fn wire2api(self) -> String {
        self
    }
}

impl Wire2Api<Vec<u8>> for Box<[u8]> {
    fn wire2api(self) -> Vec<u8> {
        self.into_vec()
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
