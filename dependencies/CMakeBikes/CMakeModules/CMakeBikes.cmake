if(NOT CMAKEBIKES)
	set(CMAKEBIKES ON)		
	
	set(CMAKEBIKES_MODULES	bikes_checkUsersOptions
							bikes_messageFuncs
							bikes_stringFuncs
							bikes_fileFuncs
							bikes_readAlien
							bikes_tools
							bikes_CMakeListsBody
							bikes_useQt
							bikes_dependenciesAnalysis
							)
							
	set(CMAKEBIKES_MODULES_FILES)
	
	foreach(m ${CMAKEBIKES_MODULES})
		include(${m})
		set(CMAKEBIKES_MODULES_FILES ${CMAKEBIKES_MODULES_FILES} "${CMAKE_MODULE_PATH}/${m}.cmake")				
	endforeach()
	
	set(CMAKEBIKES_MODULES_FILES ${CMAKEBIKES_MODULES_FILES} "${CMAKE_MODULE_PATH}/CMakeBikes.cmake")
	
	set(bikestr)
	
	foreach(f ${CMAKEBIKES_MODULES_FILES})
		file(READ ${f} fstr)
		set(bikestr "${bikestr}${fstr}")
	endforeach()
	
	
	string(MD5 bikes_md5 "${bikestr}")
	
	set(CMAKEBIKES_MODULES_UPD)
	if(bikes_md5 STREQUAL CMAKEBIKES_MODULES_MD5)
		#set(CMAKEBIKES_MODULES_UPD OFF)
	else()		
		set(CMAKEBIKES_MODULES_UPD ON)
	endif()	
	
	set(CMAKEBIKES_MODULES_MD5 ${bikes_md5} CACHE INTERNAL "")	
	
	add_custom_target(CMakeBikes SOURCES ${CMAKEBIKES_MODULES_FILES})
	
	set_property(TARGET CMakeBikes PROPERTY FOLDER CMakeBikes)
	
	message(STATUS "\nCMakeBikes Included.")
endif()