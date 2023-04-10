use super::*;
// Section: wire functions

#[no_mangle]
pub extern "C" fn wire_rust_bridge_say_hello(port_: i64) {
    wire_rust_bridge_say_hello_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_init_db(port_: i64) {
    wire_init_db_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_get_screen_size(port_: i64) {
    wire_get_screen_size_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_create_all_directory(port_: i64, s: *mut wire_uint_8_list) {
    wire_create_all_directory_impl(port_, s)
}

#[no_mangle]
pub extern "C" fn wire_new_paper(port_: i64, s: *mut wire_uint_8_list) {
    wire_new_paper_impl(port_, s)
}

#[no_mangle]
pub extern "C" fn wire_get_all_papers(port_: i64) {
    wire_get_all_papers_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_get_all_items(port_: i64) {
    wire_get_all_items_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_get_paper_by_id(port_: i64, i: i64) {
    wire_get_paper_by_id_impl(port_, i)
}

#[no_mangle]
pub extern "C" fn wire_delete_paper_by_id(port_: i64, i: i64) {
    wire_delete_paper_by_id_impl(port_, i)
}

#[no_mangle]
pub extern "C" fn wire_set_is_fav_by_id(port_: i64, i: i64, is_fav: i64) {
    wire_set_is_fav_by_id_impl(port_, i, is_fav)
}

#[no_mangle]
pub extern "C" fn wire_get_all_favs(port_: i64) {
    wire_get_all_favs_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_get_current_wall_paper(port_: i64) {
    wire_get_current_wall_paper_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_set_wall_paper(port_: i64, s: *mut wire_uint_8_list) {
    wire_set_wall_paper_impl(port_, s)
}

#[no_mangle]
pub extern "C" fn wire_set_json_path(port_: i64, s: *mut wire_uint_8_list) {
    wire_set_json_path_impl(port_, s)
}

#[no_mangle]
pub extern "C" fn wire_set_db_path(port_: i64, s: *mut wire_uint_8_list) {
    wire_set_db_path_impl(port_, s)
}

#[no_mangle]
pub extern "C" fn wire_set_gallery_id(port_: i64, id: i64) {
    wire_set_gallery_id_impl(port_, id)
}

#[no_mangle]
pub extern "C" fn wire_create_new_gallery(port_: i64, s: *mut wire_uint_8_list) {
    wire_create_new_gallery_impl(port_, s)
}

#[no_mangle]
pub extern "C" fn wire_get_parent_id(port_: i64) {
    wire_get_parent_id_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_delete_gallery_directly_by_id(port_: i64, i: i64) {
    wire_delete_gallery_directly_by_id_impl(port_, i)
}

#[no_mangle]
pub extern "C" fn wire_delete_gallery_keep_children_by_id(port_: i64, i: i64) {
    wire_delete_gallery_keep_children_by_id_impl(port_, i)
}

#[no_mangle]
pub extern "C" fn wire_download_file(
    port_: i64,
    url: *mut wire_uint_8_list,
    save_path: *mut wire_uint_8_list,
) {
    wire_download_file_impl(port_, url, save_path)
}

#[no_mangle]
pub extern "C" fn wire_get_children_by_id(port_: i64, i: i64) {
    wire_get_children_by_id_impl(port_, i)
}

#[no_mangle]
pub extern "C" fn wire_move_item(port_: i64, to_id: i64, f: *mut wire_GalleryOrWallpaper) {
    wire_move_item_impl(port_, to_id, f)
}

#[no_mangle]
pub extern "C" fn wire_set_dynamic_wallpaper(port_: i64, pid: u32) {
    wire_set_dynamic_wallpaper_impl(port_, pid)
}

// Section: allocate functions

#[no_mangle]
pub extern "C" fn new_box_autoadd_gallery_0() -> *mut wire_Gallery {
    support::new_leak_box_ptr(wire_Gallery::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_gallery_or_wallpaper_0() -> *mut wire_GalleryOrWallpaper {
    support::new_leak_box_ptr(wire_GalleryOrWallpaper::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_wall_paper_0() -> *mut wire_WallPaper {
    support::new_leak_box_ptr(wire_WallPaper::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_uint_8_list_0(len: i32) -> *mut wire_uint_8_list {
    let ans = wire_uint_8_list {
        ptr: support::new_leak_vec_ptr(Default::default(), len),
        len,
    };
    support::new_leak_box_ptr(ans)
}

// Section: related functions

// Section: impl Wire2Api

impl Wire2Api<String> for *mut wire_uint_8_list {
    fn wire2api(self) -> String {
        let vec: Vec<u8> = self.wire2api();
        String::from_utf8_lossy(&vec).into_owned()
    }
}
impl Wire2Api<Gallery> for *mut wire_Gallery {
    fn wire2api(self) -> Gallery {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<Gallery>::wire2api(*wrap).into()
    }
}
impl Wire2Api<GalleryOrWallpaper> for *mut wire_GalleryOrWallpaper {
    fn wire2api(self) -> GalleryOrWallpaper {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<GalleryOrWallpaper>::wire2api(*wrap).into()
    }
}
impl Wire2Api<WallPaper> for *mut wire_WallPaper {
    fn wire2api(self) -> WallPaper {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<WallPaper>::wire2api(*wrap).into()
    }
}
impl Wire2Api<Gallery> for wire_Gallery {
    fn wire2api(self) -> Gallery {
        Gallery {
            gallery_id: self.gallery_id.wire2api(),
            create_at: self.create_at.wire2api(),
            is_deleted: self.is_deleted.wire2api(),
            gallery_name: self.gallery_name.wire2api(),
        }
    }
}
impl Wire2Api<GalleryOrWallpaper> for wire_GalleryOrWallpaper {
    fn wire2api(self) -> GalleryOrWallpaper {
        match self.tag {
            0 => unsafe {
                let ans = support::box_from_leak_ptr(self.kind);
                let ans = support::box_from_leak_ptr(ans.Gallery);
                GalleryOrWallpaper::Gallery(ans.field0.wire2api())
            },
            1 => unsafe {
                let ans = support::box_from_leak_ptr(self.kind);
                let ans = support::box_from_leak_ptr(ans.WallPaper);
                GalleryOrWallpaper::WallPaper(ans.field0.wire2api())
            },
            _ => unreachable!(),
        }
    }
}

impl Wire2Api<Vec<u8>> for *mut wire_uint_8_list {
    fn wire2api(self) -> Vec<u8> {
        unsafe {
            let wrap = support::box_from_leak_ptr(self);
            support::vec_from_leak_ptr(wrap.ptr, wrap.len)
        }
    }
}
impl Wire2Api<WallPaper> for wire_WallPaper {
    fn wire2api(self) -> WallPaper {
        WallPaper {
            wall_paper_id: self.wall_paper_id.wire2api(),
            file_path: self.file_path.wire2api(),
            file_hash: self.file_hash.wire2api(),
            create_at: self.create_at.wire2api(),
            is_deleted: self.is_deleted.wire2api(),
            is_fav: self.is_fav.wire2api(),
        }
    }
}
// Section: wire structs

#[repr(C)]
#[derive(Clone)]
pub struct wire_Gallery {
    gallery_id: i64,
    create_at: i64,
    is_deleted: i64,
    gallery_name: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_uint_8_list {
    ptr: *mut u8,
    len: i32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_WallPaper {
    wall_paper_id: i64,
    file_path: *mut wire_uint_8_list,
    file_hash: *mut wire_uint_8_list,
    create_at: i64,
    is_deleted: i64,
    is_fav: i64,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_GalleryOrWallpaper {
    tag: i32,
    kind: *mut GalleryOrWallpaperKind,
}

#[repr(C)]
pub union GalleryOrWallpaperKind {
    Gallery: *mut wire_GalleryOrWallpaper_Gallery,
    WallPaper: *mut wire_GalleryOrWallpaper_WallPaper,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_GalleryOrWallpaper_Gallery {
    field0: *mut wire_Gallery,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_GalleryOrWallpaper_WallPaper {
    field0: *mut wire_WallPaper,
}

// Section: impl NewWithNullPtr

pub trait NewWithNullPtr {
    fn new_with_null_ptr() -> Self;
}

impl<T> NewWithNullPtr for *mut T {
    fn new_with_null_ptr() -> Self {
        std::ptr::null_mut()
    }
}

impl NewWithNullPtr for wire_Gallery {
    fn new_with_null_ptr() -> Self {
        Self {
            gallery_id: Default::default(),
            create_at: Default::default(),
            is_deleted: Default::default(),
            gallery_name: core::ptr::null_mut(),
        }
    }
}

impl NewWithNullPtr for wire_GalleryOrWallpaper {
    fn new_with_null_ptr() -> Self {
        Self {
            tag: -1,
            kind: core::ptr::null_mut(),
        }
    }
}

#[no_mangle]
pub extern "C" fn inflate_GalleryOrWallpaper_Gallery() -> *mut GalleryOrWallpaperKind {
    support::new_leak_box_ptr(GalleryOrWallpaperKind {
        Gallery: support::new_leak_box_ptr(wire_GalleryOrWallpaper_Gallery {
            field0: core::ptr::null_mut(),
        }),
    })
}

#[no_mangle]
pub extern "C" fn inflate_GalleryOrWallpaper_WallPaper() -> *mut GalleryOrWallpaperKind {
    support::new_leak_box_ptr(GalleryOrWallpaperKind {
        WallPaper: support::new_leak_box_ptr(wire_GalleryOrWallpaper_WallPaper {
            field0: core::ptr::null_mut(),
        }),
    })
}

impl NewWithNullPtr for wire_WallPaper {
    fn new_with_null_ptr() -> Self {
        Self {
            wall_paper_id: Default::default(),
            file_path: core::ptr::null_mut(),
            file_hash: core::ptr::null_mut(),
            create_at: Default::default(),
            is_deleted: Default::default(),
            is_fav: Default::default(),
        }
    }
}

// Section: sync execution mode utility

#[no_mangle]
pub extern "C" fn free_WireSyncReturn(ptr: support::WireSyncReturn) {
    unsafe {
        let _ = support::box_from_leak_ptr(ptr);
    };
}
