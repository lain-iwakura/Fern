# Генерация файла ресурса Qt из файлов с хешами.
file(GLOB SHA1_FILES ${path}/*.sha1 )
file(WRITE ${CMAKE_BINARY_DIR}/SelfTestingHashes_tmp.qrc "<RCC> <qresource prefix='/hashes'>")
foreach(_file ${SHA1_FILES})
	get_filename_component(_filename ${_file} NAME_WE)
	file(APPEND ${CMAKE_BINARY_DIR}/SelfTestingHashes_tmp.qrc "<file alias='${_filename}'>${_file}</file>")
endforeach()
file(APPEND ${CMAKE_BINARY_DIR}/SelfTestingHashes_tmp.qrc "</qresource> </RCC>")

# Проверяем, генерировали ли мы файл ресурсов. Если да, то проверяем,
# отличается ли сгенерированный файл от предыдещего сгенерированного. Если
# отличается, то заменяем, иначе оставляем все как есть.
if(EXISTS ${CMAKE_BINARY_DIR}/SelfTestingHashes.qrc )
	file(SHA1 ${CMAKE_BINARY_DIR}/SelfTestingHashes_tmp.qrc TMP_SHA1)
	file(SHA1 ${CMAKE_BINARY_DIR}/SelfTestingHashes.qrc PREVIOUS_SHA1)

	if( NOT ${TMP_SHA1} STREQUAL ${PREVIOUS_SHA1} )
		file(RENAME 
		     ${CMAKE_BINARY_DIR}/SelfTestingHashes_tmp.qrc 
		     ${CMAKE_BINARY_DIR}/SelfTestingHashes.qrc)
	endif()
else()
	file(RENAME
			 ${CMAKE_BINARY_DIR}/SelfTestingHashes_tmp.qrc
			 ${CMAKE_BINARY_DIR}/SelfTestingHashes.qrc)
endif()

# Временный файл нам более не нужен. 
file(REMOVE ${CMAKE_BINARY_DIR}/SelfTestingHashes_tmp.qrc )
