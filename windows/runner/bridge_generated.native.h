#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
typedef struct _Dart_Handle* Dart_Handle;

typedef struct DartCObject DartCObject;

typedef int64_t DartPort;

typedef bool (*DartPostCObjectFnType)(DartPort port_id, void *message);

typedef struct wire_uint_8_list {
  uint8_t *ptr;
  int32_t len;
} wire_uint_8_list;

typedef struct wire_Gallery {
  int64_t gallery_id;
  int64_t create_at;
  int64_t is_deleted;
  struct wire_uint_8_list *gallery_name;
} wire_Gallery;

typedef struct wire_GalleryOrWallpaper_Gallery {
  struct wire_Gallery *field0;
} wire_GalleryOrWallpaper_Gallery;

typedef struct wire_WallPaper {
  int64_t wall_paper_id;
  struct wire_uint_8_list *file_path;
  struct wire_uint_8_list *file_hash;
  int64_t create_at;
  int64_t is_deleted;
  int64_t is_fav;
} wire_WallPaper;

typedef struct wire_GalleryOrWallpaper_WallPaper {
  struct wire_WallPaper *field0;
} wire_GalleryOrWallpaper_WallPaper;

typedef union GalleryOrWallpaperKind {
  struct wire_GalleryOrWallpaper_Gallery *Gallery;
  struct wire_GalleryOrWallpaper_WallPaper *WallPaper;
} GalleryOrWallpaperKind;

typedef struct wire_GalleryOrWallpaper {
  int32_t tag;
  union GalleryOrWallpaperKind *kind;
} wire_GalleryOrWallpaper;

typedef struct DartCObject *WireSyncReturn;

void store_dart_post_cobject(DartPostCObjectFnType ptr);

Dart_Handle get_dart_object(uintptr_t ptr);

void drop_dart_object(uintptr_t ptr);

uintptr_t new_dart_opaque(Dart_Handle handle);

intptr_t init_frb_dart_api_dl(void *obj);

void wire_rust_bridge_say_hello(int64_t port_);

void wire_init_db(int64_t port_);

void wire_get_screen_size(int64_t port_);

void wire_create_all_directory(int64_t port_, struct wire_uint_8_list *s);

void wire_new_paper(int64_t port_, struct wire_uint_8_list *s);

void wire_get_all_papers(int64_t port_);

void wire_get_all_items(int64_t port_);

void wire_get_paper_by_id(int64_t port_, int64_t i);

void wire_delete_paper_by_id(int64_t port_, int64_t i);

void wire_set_is_fav_by_id(int64_t port_, int64_t i, int64_t is_fav);

void wire_get_current_wall_paper(int64_t port_);

void wire_set_wall_paper(int64_t port_, struct wire_uint_8_list *s);

void wire_set_json_path(int64_t port_, struct wire_uint_8_list *s);

void wire_set_db_path(int64_t port_, struct wire_uint_8_list *s);

void wire_set_gallery_id(int64_t port_, int64_t id);

void wire_create_new_gallery(int64_t port_, struct wire_uint_8_list *s);

void wire_get_parent_id(int64_t port_);

void wire_delete_gallery_directly_by_id(int64_t port_, int64_t i);

void wire_delete_gallery_keep_children_by_id(int64_t port_, int64_t i);

void wire_download_file(int64_t port_,
                        struct wire_uint_8_list *url,
                        struct wire_uint_8_list *save_path);

void wire_get_children_by_id(int64_t port_, int64_t i);

void wire_move_item(int64_t port_, int64_t to_id, struct wire_GalleryOrWallpaper *f);

struct wire_Gallery *new_box_autoadd_gallery_0(void);

struct wire_GalleryOrWallpaper *new_box_autoadd_gallery_or_wallpaper_0(void);

struct wire_WallPaper *new_box_autoadd_wall_paper_0(void);

struct wire_uint_8_list *new_uint_8_list_0(int32_t len);

union GalleryOrWallpaperKind *inflate_GalleryOrWallpaper_Gallery(void);

union GalleryOrWallpaperKind *inflate_GalleryOrWallpaper_WallPaper(void);

void free_WireSyncReturn(WireSyncReturn ptr);

static int64_t dummy_method_to_enforce_bundling(void) {
    int64_t dummy_var = 0;
    dummy_var ^= ((int64_t) (void*) wire_rust_bridge_say_hello);
    dummy_var ^= ((int64_t) (void*) wire_init_db);
    dummy_var ^= ((int64_t) (void*) wire_get_screen_size);
    dummy_var ^= ((int64_t) (void*) wire_create_all_directory);
    dummy_var ^= ((int64_t) (void*) wire_new_paper);
    dummy_var ^= ((int64_t) (void*) wire_get_all_papers);
    dummy_var ^= ((int64_t) (void*) wire_get_all_items);
    dummy_var ^= ((int64_t) (void*) wire_get_paper_by_id);
    dummy_var ^= ((int64_t) (void*) wire_delete_paper_by_id);
    dummy_var ^= ((int64_t) (void*) wire_set_is_fav_by_id);
    dummy_var ^= ((int64_t) (void*) wire_get_current_wall_paper);
    dummy_var ^= ((int64_t) (void*) wire_set_wall_paper);
    dummy_var ^= ((int64_t) (void*) wire_set_json_path);
    dummy_var ^= ((int64_t) (void*) wire_set_db_path);
    dummy_var ^= ((int64_t) (void*) wire_set_gallery_id);
    dummy_var ^= ((int64_t) (void*) wire_create_new_gallery);
    dummy_var ^= ((int64_t) (void*) wire_get_parent_id);
    dummy_var ^= ((int64_t) (void*) wire_delete_gallery_directly_by_id);
    dummy_var ^= ((int64_t) (void*) wire_delete_gallery_keep_children_by_id);
    dummy_var ^= ((int64_t) (void*) wire_download_file);
    dummy_var ^= ((int64_t) (void*) wire_get_children_by_id);
    dummy_var ^= ((int64_t) (void*) wire_move_item);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_gallery_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_gallery_or_wallpaper_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_wall_paper_0);
    dummy_var ^= ((int64_t) (void*) new_uint_8_list_0);
    dummy_var ^= ((int64_t) (void*) inflate_GalleryOrWallpaper_Gallery);
    dummy_var ^= ((int64_t) (void*) inflate_GalleryOrWallpaper_WallPaper);
    dummy_var ^= ((int64_t) (void*) free_WireSyncReturn);
    dummy_var ^= ((int64_t) (void*) store_dart_post_cobject);
    dummy_var ^= ((int64_t) (void*) get_dart_object);
    dummy_var ^= ((int64_t) (void*) drop_dart_object);
    dummy_var ^= ((int64_t) (void*) new_dart_opaque);
    return dummy_var;
}