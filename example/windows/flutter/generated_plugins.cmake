#
# Generated file, do not edit.
#

list(APPEND FLUTTER_PLUGIN_LIST
  permission_handler_windows
<<<<<<< HEAD
)

<<<<<<< HEAD
list(APPEND FLUTTER_FFI_PLUGIN_LIST
=======
>>>>>>> 20fbb3c9cc2685119294aca580f8efc45d1298b9
)

=======
>>>>>>> dev2
set(PLUGIN_BUNDLED_LIBRARIES)

foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_subdirectory(flutter/ephemeral/.plugin_symlinks/${plugin}/windows plugins/${plugin})
  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin}_plugin)
  list(APPEND PLUGIN_BUNDLED_LIBRARIES $<TARGET_FILE:${plugin}_plugin>)
  list(APPEND PLUGIN_BUNDLED_LIBRARIES ${${plugin}_bundled_libraries})
endforeach(plugin)
