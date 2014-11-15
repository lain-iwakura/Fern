# bikes_checkUsersOptions
#===============================================================================
macro(CMakeBikes_init)
	get_curent_dir_name(THIS_DIR)
	get_sub_project_flag(IS_SUB_PROJECT) 
	set(PARENT_PROJECT_NAME ${PROJECT_NAME})
	
	
	set(PRINT_MESSAGES)
	
	set(EXTRA_SOURCEDIRS)
	
	set(EXTRA_HEADERS)
	set(EXTRA_SOURCES)	
	set(EXTRA_QT_RESOURCES)
	set(EXTRA_QT_SOURCES_FOR_MOC)
	set(EXTRA_QT_UI)
	
	set(OUT_BIN_PREFIX)
	set(DEF_FOR_STATIC_EXPORT)
	set(DEF_FOR_SHARED_EXPORT)
	set(DEF_FOR_DISABLE_INCLUDE_MOC)
	set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY)
	set(CMAKE_LIBRARY_OUTPUT_DIRECTORY)
	set(CMAKE_RUNTIME_OUTPUT_DIRECTORY)
	set(CMAKE_INSTALL_PREFIX)
	set(TARGET_NAME)
	set(HINT_PUBLIC_INCLUDE_PREFIX)
	
	set(PROJECT_NAME) # AUTO|<THE_NAME_OF_PROJECT>
	set(PROJECT_TYPE) # AUTO|EXECUTABLE|SHARED_LIB|STATIC_LIB|SHARED_OR_STATIC_LIB|HEADERS_LIB|AGGREGATION
	set(REQUIRED_LIBS) # NO|[AUTO][DEPENDENCIES][PARENT_DEPENDENCIES][<REQUIRED_LIBS_LIST>]
	set(REQUIRED_INCLUDE) # NO|[<REQUIRED_TARGETS_LIST>]
	set(ADDITIONAL_INCLUDE_DIRS) # NO|<INCLUDE_DIRS_LIST>
	set(PRIVATE_DEFINITIONS) # NO|<DEFINITIONS_LIST>
	set(USERS_INCLUDE) # NO|[AUTO][PUBLIC][PRIVATE][DEPENDENCIES][ADDITIONAL][<INCLUDE_TARGETS_LIST>][<INCLUDE_DIRS_LIST>]
	set(USERS_DEFINITIONS) # NO|[AUTO][STATIC_EXPORT][SHARED_EXPORT][PRIVATE][<DEFINITIONS_LIST>]
	set(USE_PRECOMPILED_HEADER) # NO|AUTO|<HEADER_PATH>
	set(USE_BOOST) # ON|OFF
	set(USE_QT) # ON|OFF|[ON][AUTOMOC][CORE][MAIN][GUI][OPENGL][SVG][XML][SQL][NETWORK][3SUPPORT][WEBKIT][HELP][TEST]
	set(USE_INSTALL) # ON|OFF|<INSTALL_PATH>
	#set(USE_VLD) #ON|OFF	
	
endmacro()
#===============================================================================
function(check_users_options_NO inout_options)
	set(opt ${${inout_options}})
	if(opt)
		list(REMOVE_ITEM opt NO OFF FALSE)
	else()
		set(opt)
	endif()
	set(${inout_options} ${opt} PARENT_SCOPE)
endfunction()
#===============================================================================
macro(check_users_options)

	if(DEFINED PROJECT_TYPE)
		list(GET PROJECT_TYPE 0 v)
		set(PROJECT_TYPE ${v})
		if(PROJECT_TYPE)
			set(PROJECT_TYPE_CHECK  AUTO EXECUTABLE SHARED_LIB STATIC_LIB SHARED_OR_STATIC_LIB STATIC_OR_SHARED_LIB HEADERS_LIB AGGREGATION)
			list(FIND PROJECT_TYPE_CHECK ${PROJECT_TYPE} f)
			if(${f} EQUAL -1)
				set(PROJECT_TYPE AUTO)
			endif()
		else()
			set(PROJECT_TYPE AUTO)
		endif()
	else()
		set(PROJECT_TYPE AUTO)
	endif()
	
	# messages ->	
	if(DEFINED ${PROJECT_NAME}_PRINT_MESSAGES)
		set(PRINT_MESSAGES ${${PROJECT_NAME}_PRINT_MESSAGES})
	elseif(DEFINED ${PARENT_PROJECT_NAME}_PRINT_MESSAGES)
		set(PRINT_MESSAGES ${${PARENT_PROJECT_NAME}_PRINT_MESSAGES})
	endif()
	ifnodef_set(PRINT_MESSAGES NO)
	set(${PROJECT_NAME}_PRINT_MESSAGES ${PRINT_MESSAGES})
	# <- messages
	
	#ifnodef_set(PROJECT_NAME AUTO)
	ifnodef_set(REQUIRED_LIBS AUTO)
	ifnodef_set(REQUIRED_INCLUDE NO)
	ifnodef_set(ADDITIONAL_INCLUDE_DIRS NO)
	ifnodef_set(PRIVATE_DEFINITIONS NO)
	ifnodef_set(USERS_INCLUDE AUTO)
	ifnodef_set(USERS_DEFINITIONS AUTO)
	ifnodef_set(USE_PRECOMPILED_HEADER AUTO)
	ifnodef_set(USE_BOOST OFF)
	ifnodef_set(USE_QT OFF)
	ifnodef_set(USE_INSTALL .)
	ifnodef_set(USE_VLD OFF)


	ifndef_set(OUT_ROOT_DIR			${CMAKE_BINARY_DIR})
	ifndef_set(OUT_LIB_DIR			lib)	
	ifndef_set(OUT_BIN_DIR			bin)
	#ifndef_set(OUT_BIN_PREFIX		.)
	ifndef_set(OUT_INSTALL_DIR		dist)	
	ifndef_set(HINT_SOURCES_DIR             src sources)  
	ifndef_set(HINT_INCLUDE_DIR	            include headers) 
	ifnodef_set(HINT_PUBLIC_INCLUDE_PREFIX	${PROJECT_NAME}) #!
	ifndef_set(HINT_DEPENDENCIES_DIR        dependencies libraries libs) 
	ifndef_set(HINT_SAMPLES_DIR             sample* demo* test* tools) 
	ifndef_set(HINT_RESOURCES_DIR           resource*)
	ifndef_set(HINT_IGNOR_DIRS              .git build* CMake* doc) 
	# <- Каталоги

	# Файлы ->
	ifndef_set(HINT_PRECOMPILED_HEADER	precompil* prerequisit* )
	ifndef_set(HINT_EXPORT_HEADER       export* )
	ifndef_set(HINT_MAIN_SOURCE         main )
	# <- Файлы

	# Расширения файлов ->
	ifndef_set(HINT_EXT_HEADERS			h hpp )
	ifndef_set(HINT_EXT_SOURCES			cpp cc c )
	ifndef_set(HINT_EXT_QT_RESOURCES	qrc )
	ifndef_set(HINT_EXT_QT_UI			ui )
	ifndef_set(OUT_EXT_MOC				cxx)
	# <- Расширения файлов 

	# Определения препроцесcора ->
	if(NOT DEFINED DEF_FOR_STATIC_EXPORT)
		set(DEF_FOR_STATIC_EXPORT	${PROJECT_NAME}_STATICLIB )
		string(TOUPPER ${DEF_FOR_STATIC_EXPORT} DEF_FOR_STATIC_EXPORT)
	endif()
	if(NOT DEFINED DEF_FOR_SHARED_EXPORT)
		set(DEF_FOR_SHARED_EXPORT	${PROJECT_NAME}_SHAREDLIB )
		string(TOUPPER ${DEF_FOR_SHARED_EXPORT} DEF_FOR_SHARED_EXPORT)
	endif()
	ifndef_set(DEF_FOR_DISABLE_INCLUDE_MOC DISABLE_INCLUDING_MOC_FILES_TO_SOURCES)
	# <- Определения препроцесcора 

	# Цель ->
	ifnodef_set(TARGET_NAME ${PROJECT_NAME})
	# <- Цель
	
	ifndef_set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${OUT_ROOT_DIR}/${OUT_LIB_DIR})
	ifndef_set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${OUT_ROOT_DIR}/${OUT_BIN_DIR})
	ifndef_set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${OUT_ROOT_DIR}/${OUT_BIN_DIR})
	ifndef_set(CMAKE_INSTALL_PREFIX ${OUT_ROOT_DIR}/${OUT_INSTALL_DIR})
	
	set(HINT_IGNOR_DIRS ${HINT_IGNOR_DIRS} 
						${CMAKE_BINARY_DIR}
						${OUT_ROOT_DIR}
						${CMAKE_ARCHIVE_OUTPUT_DIRECTORY} 
						${CMAKE_LIBRARY_OUTPUT_DIRECTORY} 
						${CMAKE_RUNTIME_OUTPUT_DIRECTORY} 
						${CMAKE_INSTALL_PREFIX}
						)
	list(REMOVE_DUPLICATES HINT_IGNOR_DIRS)


	
	if(OUT_BIN_PREFIX)
		if(CMAKE_CONFIGURATION_TYPES)
			foreach(t ${CMAKE_CONFIGURATION_TYPES})	
				string(TOUPPER ${t} tt)
				set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${tt} ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${t}/${OUT_BIN_PREFIX} )
				set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${tt} ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${t}/${OUT_BIN_PREFIX} )
				#message_var(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${tt})
			endforeach()
		else()
			set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${OUT_BIN_PREFIX} )
			set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${OUT_BIN_PREFIX} )
		endif()
	endif()

	check_users_options_NO(REQUIRED_LIBS)
	check_users_options_NO(REQUIRED_INCLUDE)
	check_users_options_NO(ADDITIONAL_INCLUDE_DIRS)
	check_users_options_NO(PRIVATE_DEFINITIONS)
	check_users_options_NO(USERS_INCLUDE)
	check_users_options_NO(USERS_DEFINITIONS)
	check_users_options_NO(USE_PRECOMPILED_HEADER)
	check_users_options_NO(USE_BOOST)
	check_users_options_NO(USE_QT)
	check_users_options_NO(USE_VLD)
	check_users_options_NO(USE_INSTALL)
	check_users_options_NO(OUT_BIN_PREFIX)	

	
	
endmacro()
#===============================================================================

