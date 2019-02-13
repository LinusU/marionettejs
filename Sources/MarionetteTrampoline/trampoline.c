#include <NAPI.h>

napi_value _init_marionettejs(napi_env, napi_value);

NAPI_MODULE(marionettejs, _init_marionettejs)
