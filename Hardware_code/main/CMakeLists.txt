set(srcs "main.c"
         "connect_wifi.c")
idf_component_register(SRCS ${srcs}
                    INCLUDE_DIRS "."
                    REQUIRES driver freertos nvs_flash esp32-camera esp_http_server esp_timer esp_wifi)