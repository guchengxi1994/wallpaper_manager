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

void wire_set_gallery_id(int64_t port_, int64_t id);

void wire_create_new_gallery(int64_t port_, struct wire_uint_8_list *s);

struct wire_uint_8_list *new_uint_8_list_0(int32_t len);

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
    dummy_var ^= ((int64_t) (void*) wire_set_gallery_id);
    dummy_var ^= ((int64_t) (void*) wire_create_new_gallery);
    dummy_var ^= ((int64_t) (void*) new_uint_8_list_0);
    dummy_var ^= ((int64_t) (void*) free_WireSyncReturn);
    dummy_var ^= ((int64_t) (void*) store_dart_post_cobject);
    dummy_var ^= ((int64_t) (void*) get_dart_object);
    dummy_var ^= ((int64_t) (void*) drop_dart_object);
    dummy_var ^= ((int64_t) (void*) new_dart_opaque);
    return dummy_var;
}