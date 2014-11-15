# bikes_CMakeListsBody
#===============================================================================
macro(CMakeBikes_run)

ifnodef_set(PROJECT_NAME AUTO)
if(${PROJECT_NAME} STREQUAL AUTO)
	set(PROJECT_NAME ${THIS_DIR})
endif()
#...............................................................................
# Имя проекта ->
if((NOT IS_SUB_PROJECT) OR (NOT CMAKEBIKES_FIRSTPASSAGE))
	project(${PROJECT_NAME})
endif()
# <- Имя проекта
#...............................................................................
# Проверка опций ->
check_users_options()
# <- Проверка опций
#...............................................................................
if(PRINT_MESSAGES)
	if(CMAKEBIKES_FIRSTPASSAGE)
		message("\nCMakeBikes runned for ${PROJECT_NAME} (first passage) ->")
	else()
		message("\nCMakeBikes runned for ${PROJECT_NAME} ->")
	endif()
endif()
#...............................................................................
# Вывод основных опций ->
	message_var(CMAKE_ARCHIVE_OUTPUT_DIRECTORY)
	message_var(CMAKE_LIBRARY_OUTPUT_DIRECTORY)
	message_var(CMAKE_RUNTIME_OUTPUT_DIRECTORY)
	message_var(CMAKE_INSTALL_PREFIX)
	message_var(PROJECT_TYPE) # AUTO|EXECUTABLE|SHARED_LIB|STATIC_LIB|SHARED_OR_STATIC_LIB|HEADERS_LIB|AGGREGATION
	message_var(REQUIRED_LIBS) # NO|[AUTO][DEPENDENCIES][PARENT_DEPENDENCIES][<REQUIRED_LIBS_LIST>]
	message_var(REQUIRED_INCLUDE) # NO|[<REQUIRED_TARGETS_LIST>]
	message_var(ADDITIONAL_INCLUDE_DIRS) # NO|<INCLUDE_DIRS_LIST>
	message_var(PRIVATE_DEFINITIONS) # NO|<DEFINITIONS_LIST>
	message_var(USERS_INCLUDE) # NO|[AUTO][PUBLIC][PRIVATE][DEPENDENCIES][ADDITIONAL][<INCLUDE_TARGETS_LIST>][<INCLUDE_DIRS_LIST>]
	message_var(USERS_DEFINITIONS) # NO|[AUTO][STATIC_EXPORT][SHARED_EXPORT][PRIVATE][<DEFINITIONS_LIST>]
	message_var(USE_PRECOMPILED_HEADER) # NO|AUTO|<HEADER_PATH>
	message_var(USE_BOOST) # ON|OFF
	message_var(USE_QT) # ON|OFF|[ON][AUTOMOC][CORE][MAIN][GUI][OPENGL][SVG][XML][SQL][NETWORK][3SUPPORT][WEBKIT][HELP][TEST]
	message_var(USE_INSTALL) # ON|OFF|<INSTALL_PATH>
	message_var(USE_VLD)
# <- Вывод основных опций
#...............................................................................
# Первый проход ->
if(NOT IS_SUB_PROJECT)
	set(CMAKEBIKES_FIRSTPASSAGE ON)
endif()

if(CMAKEBIKES_FIRSTPASSAGE)				
	# Собственные зависимости ->   ?	
	set(ALL_DEPENDENCIES ${REQUIRED_INCLUDE} ${REQUIRED_LIBS})
	# <- Собственные зависимости 		
		
	# Собственные синонимы ->
	set(ALIASES)
	if(NOT (${PROJECT_NAME} STREQUAL ${TARGET_NAME}))
		set(ALIASES ${TARGET_NAME})		
	endif()
	# <- Собственные синонимы
	
	# Зависимости подпроектов ->
	find_dirs(${CMAKE_CURRENT_SOURCE_DIR} HINT_DEPENDENCIES_DIR dpn_dirs)
	find_dirs(${CMAKE_CURRENT_SOURCE_DIR} HINT_SAMPLES_DIR smp_dirs)
	list_dirs_without_cmakelists(${CMAKE_CURRENT_SOURCE_DIR} src_dirs)
	if(src_dirs AND (dpn_dirs OR smp_dirs))
		list(REMOVE_ITEM src_dirs ${dpn_dirs} ${smp_dirs})
	endif()
	
	add_subdirs(CMAKE_CURRENT_SOURCE_DIR OFF SUBPROJECTS_ROOT)
	foreach(p ${SUBPROJECTS_ROOT})
			set(CMAKEBIKES_${p}_LOCATIONTYPE ROOT)
	endforeach()
	set(SUBPROJECTS_DPN)
	if(dpn_dirs)
		add_subdirs(dpn_dirs ON SUBPROJECTS_DPN)
		foreach(p ${SUBPROJECTS_DPN})
			set(CMAKEBIKES_${p}_LOCATIONTYPE DEPENDENCIES)
		endforeach()
	endif()
	set(SUBPROJECTS_SRC)
	if(src_dirs)
		add_subdirs(src_dirs ON SUBPROJECTS_SRC)
		foreach(p ${SUBPROJECTS_SRC})
			set(CMAKEBIKES_${p}_LOCATIONTYPE SOURCES)
		endforeach()
	endif()		
	set(SUBPROJECTS_SMP)
	if(smp_dirs)
		add_subdirs(smp_dirs ON SUBPROJECTS_SMP)
		foreach(p ${SUBPROJECTS_SMP})
			set(CMAKEBIKES_${p}_LOCATIONTYPE SAMPLES)
		endforeach()		
	endif()
	set(SUBPROJECTS_ALL ${SUBPROJECTS_DPN} ${SUBPROJECTS_ROOT} ${SUBPROJECTS_SRC} ${SUBPROJECTS_SMP})
	message_var(SUBPROJECTS_ALL)
	
	if(SUBPROJECTS_ALL)		
		# Синонимы += Синонимы подпроектов ->
		get_subvariables_list(SUBPROJECTS_ALL CMAKEBIKES_ _ALIASES SUBPROJECTS_ALIASES)			
		set(ALIASES ${ALIASES} ${SUBPROJECTS_ALL} ${SUBPROJECTS_ALIASES})
		list(REMOVE_DUPLICATES ALIASES)
		list(REMOVE_ITEM ALIASES ${PROJECT_NAME})
		# <- Синонимы += Синонимы подпроектов 
	
		# Зависимости += Зависимости подпроектов ->
		get_subvariables_list(SUBPROJECTS_ALL CMAKEBIKES_ _DEPENDENCIES SUB_DPN)						
		if(SUB_DPN)
			list(REMOVE_DUPLICATES SUB_DPN)
			list(REMOVE_ITEM SUB_DPN ${PROJECT_NAME} ${ALIASES})
			set(ALL_DEPENDENCIES ${ALL_DEPENDENCIES} ${SUB_DPN})
		endif()		
		# <- Зависимости += Зависимости подпроектов
	endif()		
	# <- Зависимости подпроектов
	
	if(ALL_DEPENDENCIES)
		list(REMOVE_DUPLICATES ALL_DEPENDENCIES)
	endif()
	
	# Порядок включения подпроектов ->
	set(SUBPROJECTS_SEQUENCE)
	if(SUBPROJECTS_ALL)
		get_dependencies_sequence(SUBPROJECTS_ALL SUBPROJECTS_SEQUENCE)
	endif()
	# <- Порядок включения подпроектов 	
	
	# Глобальные переменные проекта ->
	set(CMAKEBIKES_${PROJECT_NAME}_SUBPROJECTS_SEQUENCE ${SUBPROJECTS_SEQUENCE})
	set(CMAKEBIKES_${PROJECT_NAME}_SUBPROJECTS_LIST ${SUBPROJECTS_ALL})
	set(CMAKEBIKES_${PROJECT_NAME}_DEPENDENCIES ${ALL_DEPENDENCIES})
	set(CMAKEBIKES_${PROJECT_NAME}_ALIASES ${ALIASES})
	set(CMAKEBIKES_${PROJECT_NAME}_PATH ${CMAKE_CURRENT_SOURCE_DIR})	
	get_filename_component(CMAKEBIKES_${PROJECT_NAME}_PATH ${CMAKEBIKES_${PROJECT_NAME}_PATH} ABSOLUTE)
	# <- Глобальные переменные проекта		
	
	message_var(CMAKEBIKES_${PROJECT_NAME}_SUBPROJECTS_SEQUENCE)
	message_var(CMAKEBIKES_${PROJECT_NAME}_ALIASES)
	message_var(CMAKEBIKES_${PROJECT_NAME}_PATH)
	
	if(IS_SUB_PROJECT)
		push_up_project_variables(${PROJECT_NAME})
		set(CMAKEBIKES_TMP_SUBPROJECT_NAME ${PROJECT_NAME} PARENT_SCOPE)		
		If(PRINT_MESSAGES)
			# if(CMAKEBIKES_FIRSTPASSAGE)
				message("\n<- CMakeBikes stoped for ${PROJECT_NAME} (first passage)")
			# else()
				# message("\n<- CMakeBikes stoped for ${PROJECT_NAME}")
			# endif()	
		else()
			# if(CMAKEBIKES_FIRSTPASSAGE)
				message(STATUS "CMakeBikes executed for ${PROJECT_NAME} (first passage)")
			# else()
				# message(STATUS "CMakeBikes executed for ${PROJECT_NAME}")
			# endif()
		endif()	
		return() #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!!!!!!!!!!!!!!!!!
	else()
	endif()
endif()
# <- Первый проход
#...............................................................................
set(CMAKEBIKES_FIRSTPASSAGE)	
#...............................................................................
# Дополнительные опции ->
#set(CMAKE_USE_RELATIVE_PATHS TRUE)
set_property(GLOBAL PROPERTY USE_FOLDERS ON)
# <- Дополнительные опции 
#...............................................................................
# Инициализация переменных ->
set(CMAKEBIKES_SUBDIR_INDEX 0)

set(USE_QT_AUTOMOC)
set(ANYFILE *)
set(ANYFILES *)
set(LINK_LIST)
set(TMP_SUBPROJECT_NAME)
set(SUBPROJECTS_LIST)
set(REQUIRED_INCLUDE_DIRS)
set(TARGET_LIST)
set(IGNOR_DIRS)
file(GLOB fdirs ${HINT_IGNOR_DIRS})

foreach(fd ${fdirs})
	if(IS_DIRECTORY ${fd})
		set(IGNOR_DIRS ${IGNOR_DIRS} ${fd})
	endif()
endforeach()
list(REMOVE_DUPLICATES IGNOR_DIRS)
message_var(IGNOR_DIRS)

message_var(IS_SUB_PROJECT)
if(NOT PRIVATE_DEFINITIONS)
	set(PRIVATE_DEFINITIONS)
endif()

set(PARENT_DEPENDENCIES_LIBS ${CMAKEBIKES_DEPENDENCIES_LIBS})

set(SOURCEDIRS ${CMAKE_CURRENT_SOURCE_DIR})
if(EXTRA_SOURCEDIRS)
	set(SOURCEDIRS ${SOURCEDIRS} ${EXTRA_SOURCEDIRS})
endif()
# <- Инициализация переменных
#...............................................................................
# Поиск исходников ->
br()
find_project_files(SOURCEDIRS ANYFILE HINT_EXT_HEADERS HFILES)
if(EXTRA_HEADERS)
	set(HFILES ${HFILES} ${EXTRA_HEADERS})
endif()
message_var(HFILES)
find_project_files(SOURCEDIRS ANYFILE HINT_EXT_SOURCES SFILES)
if(EXTRA_SOURCES)
	set(SFILES ${SFILES} ${EXTRA_SOURCES})
endif()
message_var(SFILES)
set(SHFILES ${HFILES} ${SFILES})
set(TFILES ${SHFILES})
# <- Поиск исходников
#..............................................................................
# Определение личных каталогов включения ->
br()
if(HFILES)
	get_files_dir_list(HFILES PRIVATE_INCLUDE_DIRS)
	get_public_include_dirs(PRIVATE_INCLUDE_DIRS HINT_PUBLIC_INCLUDE_PREFIX PUBLIC_INCLUDE_DIRS)		
else()
	set(PRIVATE_INCLUDE_DIRS)
	set(PUBLIC_INCLUDE_DIRS)
endif()
message_var(PRIVATE_INCLUDE_DIRS)
message_var(PUBLIC_INCLUDE_DIRS)
# <- Определение личных каталогов включения
#...............................................................................
br()
# Определение типа проекта ->
if(${PROJECT_TYPE} STREQUAL AUTO)
	if((NOT HFILES) AND (NOT SFILES))
		set(PROJECT_TYPE AGGREGATION)
	else()
		if(SFILES)
			if(HFILES)
				find_project_files(SOURCEDIRS HINT_EXPORT_HEADER HINT_EXT_HEADERS EFILES)
				if(EFILES)
					set(PROJECT_TYPE SHARED_LIB)
				else()
					find_project_files(SOURCEDIRS HINT_MAIN_SOURCE HINT_EXT_SOURCES MAINFILE)
					if(MAINFILE)
						set(PROJECT_TYPE EXECUTABLE)
					else()
						set(PROJECT_TYPE STATIC_LIB)
					endif()
				endif()
			else()
				set(PROJECT_TYPE EXECUTABLE)
			endif()
		else()
			set(PROJECT_TYPE HEADERS_LIB)
		endif()
	endif()
endif()
message_var(PROJECT_TYPE)
# <- Определение типа проекта
#..............................................................................
# Определение цели(целей?) ->
set(EXEC_OUT)
set(LIB_OUT)
set(HLIB_OUT)
set(EXPORT_DEFINITION)
set(TARGET_EXISTS)
if(${PROJECT_TYPE} STREQUAL EXECUTABLE)	
	if(MSVC)
		set(EXEC_TYPE WIN32)
	else()
		set(EXEC_TYPE)
	endif()
	set(${TARGET_NAME}_TYPE EXEC)
	set(${TARGET_NAME}_TYPE_PARAM ${EXEC_TYPE})	
	set(EXEC_OUT ${TARGET_NAME})
	set(TARGET_LIST ${TARGET_LIST} ${TARGET_NAME})	
	#add_executable(${TARGET_NAME} ${EXEC_TYPE} ${TFILES} )
	set(TARGET_EXISTS true)
elseif(${PROJECT_TYPE} STREQUAL  HEADERS_LIB)
	set(${TARGET_NAME}_TYPE HLIB)
	set(${TARGET_NAME}_TYPE_PARAM)
	set(HLIB_OUT ${TARGET_NAME})
	set(TARGET_LIST ${TARGET_LIST} ${TARGET_NAME})	
	set(TARGET_EXISTS true)
elseif( NOT (${PROJECT_TYPE} STREQUAL AGGREGATION) )

	if(${PROJECT_TYPE} STREQUAL SHARED_OR_STATIC_LIB)
		option(${PROJECT_NAME}_STATIC "Статическая сборка" OFF)		
		if(${PROJECT_NAME}_STATIC)
			set(PROJECT_TYPE STATIC_LIB)
		else()
			set(PROJECT_TYPE SHARED_LIB)
		endif()
	elseif(${PROJECT_TYPE} STREQUAL STATIC_OR_SHARED_LIB)
		option(${PROJECT_NAME}_STATIC "Статическая сборка" ON)		
		if(${PROJECT_NAME}_STATIC)
			set(PROJECT_TYPE STATIC_LIB)
		else()
			set(PROJECT_TYPE SHARED_LIB)
		endif()
	endif()

	if(${PROJECT_TYPE} STREQUAL SHARED_LIB)
		set(LIB_TYPE SHARED)
		set(EXPORT_DEFINITION ${DEF_FOR_SHARED_EXPORT})
	else()
		set(LIB_TYPE STATIC)		
		set(EXPORT_DEFINITION ${DEF_FOR_STATIC_EXPORT})
	endif()
	set(${TARGET_NAME}_TYPE LIB)
	set(${TARGET_NAME}_TYPE_PARAM ${LIB_TYPE})	
	set(LIB_OUT ${TARGET_NAME})
	set(TARGET_LIST ${TARGET_LIST} ${TARGET_NAME})	
	#add_library(${TARGET_NAME} ${LIB_TYPE} ${TFILES})	
	set(TARGET_EXISTS true)
else()	
	set(TARGET_EXISTS false)
endif()
message_var(LIB_OUT)
message_var(EXEC_OUT)
message_var(TARGET_LIST)
# <- Определение цели(целей?)
#...............................................................................
#===============================================================================
#...............................................................................
# Подключение подпроектов ->
br()

if(NOT (${PROJECT_TYPE} STREQUAL AGGREGATION))
	set(USE_VLD)
endif()

message_var(CMAKEBIKES_${PROJECT_NAME}_SUBPROJECTS_SEQUENCE)
set(projseq ${CMAKEBIKES_${PROJECT_NAME}_SUBPROJECTS_SEQUENCE})

if(projseq)
	add_subdirs_sequence(projseq SUBPROJECTS SUBPROJECTS_DPN)
	if(SUBPROJECTS_DPN)	
		get_subvariables_list(SUBPROJECTS_DPN CMAKEBIKES_ _LIB_LIST LIBS_DPN)
	endif()
else()
	find_dirs(${CMAKE_CURRENT_SOURCE_DIR} HINT_DEPENDENCIES_DIR dpn_dirs)
	find_dirs(${CMAKE_CURRENT_SOURCE_DIR} HINT_SAMPLES_DIR smp_dirs)
	list_dirs_without_cmakelists(${CMAKE_CURRENT_SOURCE_DIR} src_dirs)
	if(src_dirs AND (dpn_dirs OR smp_dirs))
		list(REMOVE_ITEM src_dirs ${dpn_dirs} ${smp_dirs})
	endif()

	#set(PARENT_DEPENDENCIES_LIBS ${CMAKEBIKES_DEPENDENCIES_LIBS})
	#message_var(PARENT_DEPENDENCIES_LIBS)

	#set(CMAKEBIKES_DEPENDENCIES_LIBS)
	set(SUBPROJECTS_DPN)
	if(dpn_dirs)
		add_subdirs(dpn_dirs ON SUBPROJECTS_DPN)
	endif()

	set(LIBS_DPN)
	if(SUBPROJECTS_DPN)	
		get_subvariables_list(SUBPROJECTS_DPN CMAKEBIKES_ _LIB_LIST LIBS_DPN)
	endif()

	set(SUBPROJECTS_SRC)
	set(CMAKEBIKES_DEPENDENCIES_LIBS ${PARENT_DEPENDENCIES_LIBS} ${LIBS_DPN})
	add_subdirs(CMAKE_CURRENT_SOURCE_DIR OFF SUBPROJECTS_ROOT)
	if(src_dirs)
		add_subdirs(src_dirs ON SUBPROJECTS_SRC)
	endif()

	set(SUBPROJECTS_SMP)
	set(CMAKEBIKES_DEPENDENCIES_LIBS ${CMAKEBIKES_DEPENDENCIES_LIBS} ${LIB_OUT})
	if(smp_dirs)
		option(${PROJECT_NAME}_SAMPLES "Include ${PROJECT_NAME}'s sample-projects." ON)
		if(${PROJECT_NAME}_SAMPLES)
			add_subdirs(smp_dirs ON SUBPROJECTS_SMP)
		endif()
	endif()

	set(CMAKEBIKES_DEPENDENCIES_LIBS ${PARENT_DEPENDENCIES_LIBS} ${LIBS_DPN})

	set(SUBPROJECTS 
		${SUBPROJECTS_ROOT}
		${SUBPROJECTS_DPN} 
		${SUBPROJECTS_SMP} 
		${SUBPROJECTS_SRC}
		)
endif()

set(SUBSUBPROJECTS)
foreach(p ${SUBPROJECTS})
	get_all_subproject_list(${p} spl)
	set(SUBSUBPROJECTS ${SUBSUBPROJECTS} ${spl})
endforeach()
set(SUBPROJECTS_ALL ${SUBPROJECTS} ${SUBSUBPROJECTS})

message_var(SUBPROJECTS)
message_var(SUBPROJECTS_ALL)
#foreach(p ${SUBPROJECTS_ALL})	
#	message_project_vars(${p})
#endforeach()
# <- Подключение подпроектов 
#...............................................................................
# Компоновка проекта ->
set(LINK_LIST)
set(LINK_LIBS)

if(REQUIRED_LIBS)
	list(REMOVE_DUPLICATES REQUIRED_LIBS)
	list(FIND REQUIRED_LIBS AUTO f)
	if(NOT (${f} EQUAL -1))
		set(LINK_LIBS ${LINK_LIBS} ${PARENT_DEPENDENCIES_LIBS} ${LIBS_DPN})
	endif()	
	list(REMOVE_ITEM REQUIRED_LIBS AUTO)
	set(LINK_LIBS ${LINK_LIBS} ${REQUIRED_LIBS})	
	if(LINK_LIBS)
		list(REMOVE_DUPLICATES LINK_LIBS)
	endif()
	set(LINK_LIST ${LINK_LIST} ${LINK_LIBS})
endif()

message_var(LINK_LIBS)
#message_var(LINK_LIST)
# <- Компоновка проекта
#...............................................................................
# Поиск и подключение пакетов ->
include_qt()
if(USE_BOOST)
	find_package(Boost REQUIRED)	
	set(REQUIRED_INCLUDE_DIRS ${REQUIRED_INCLUDE_DIRS} ${Boost_INCLUDE_DIR})
endif()
if(VLD_ENABLED)
	find_package(VLD)
	if(VLD_FOUND)
		set_directory_properties(PROPERTIES
			COMPILE_DEFINITIONS HAVE_VLD_H
			INCLUDE_DIRECTORIES ${VLD_INCLUDE_DIRS}
		)
	else()
		set(VLD_ENABLED)
	endif()
endif()
# <- Поиск и подключение пакетов
#...............................................................................
# Предварительное определение внешних каталогов включения ->
set(BAD_LIBS)
set(RLINK)

if(LINK_LIBS)
	get_required_include_dirs(LINK_LIBS rid BAD_LIBS)
	set(REQUIRED_INCLUDE_DIRS ${REQUIRED_INCLUDE_DIRS} ${rid})
endif()

if(REQUIRED_INCLUDE)
	get_required_include_dirs(REQUIRED_INCLUDE RID BL)
	set(REQUIRED_INCLUDE_DIRS ${REQUIRED_INCLUDE_DIRS} ${RID})
	set(BAD_LIBS ${BAD_LIBS} ${BL})
endif()

if(REQUIRED_INCLUDE_DIRS)
	list(REMOVE_DUPLICATES REQUIRED_INCLUDE_DIRS)
else()
	set(REQUIRED_INCLUDE_DIRS)
endif()

#message_var(REQUIRED_INCLUDE_DIRS)
message_var(BAD_LIBS)

if(NOT ADDITIONAL_INCLUDE_DIRS)
	set(ADDITIONAL_INCLUDE_DIRS)
endif()

set(INCLUDE_DIRS ${PRIVATE_INCLUDE_DIRS} ${PUBLIC_INCLUDE_DIRS} ${REQUIRED_INCLUDE_DIRS} ${ADDITIONAL_INCLUDE_DIRS})


if(USE_QT)			
#	message_var(${PROJECT_NAME}_BINARY_DIR)
	set(INCLUDE_DIRS ${INCLUDE_DIRS} ${${PROJECT_NAME}_BINARY_DIR})
endif()
# <- Предварительное определение внешних каталогов включения
#...............................................................................
if(INCLUDE_DIRS)
	list(REMOVE_DUPLICATES INCLUDE_DIRS)
	include_directories(${INCLUDE_DIRS}) #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!!!!!!!!!!!!!!!!!!
endif()
#...............................................................................
get_property(INCLUDED_DIRS DIRECTORY PROPERTY INCLUDE_DIRECTORIES)
message_var(INCLUDED_DIRS)
# Генерируемые файлы ->
set(GFILES)
if(USE_QT)

#moc->
	set(MFILES)
	set(GEN_MOC_SOURCES)		
	if(USE_QT_AUTOMOC)		
		message_var(USE_QT_AUTOMOC)
	else()
		#find_moc_files(SHFILES GEN_MOC_SOURCES)		
			
		set(moc_words Q_OBJECT)
		find_files_with_words(SHFILES moc_words MFILES)
		
		if(EXTRA_QT_SOURCES_FOR_MOC)
			set(MFILES ${MFILES} ${EXTRA_QT_SOURCES_FOR_MOC})
		endif()		
		
		if(MFILES)
			list(REMOVE_DUPLICATES MFILES)
			CMAKEBIKES_QT4_WRAP_CPP(${OUT_EXT_MOC} GEN_MOC_SOURCES ${MFILES})			
		endif()		
		message_var(GEN_MOC_SOURCES)
	endif()
#<-moc	

#qrc->
	set(QRCFILES)
	set(GEN_QRC_SOURCES)
#	find_qrc_files(SOURCEDIRS QRCFILES GEN_QRC_SOURCES)
	find_project_files(SOURCEDIRS ANYFILE HINT_EXT_QT_RESOURCES QRCFILES)
	if(EXTRA_QT_RESOURCES)		
		set(QRCFILES ${QRCFILES} ${EXTRA_QT_RESOURCES})
	endif()
	if(QRCFILES)
		list(REMOVE_DUPLICATES QRCFILES)
		qt4_add_resources(GEN_QRC_SOURCES ${QRCFILES})
	endif()
	message_var(QRCFILES)
	message_var(GEN_QRC_SOURCES)	
#<-qrc

#ui->
	set(UIFILES)
	set(GEN_UI_SOURCES)
	find_project_files(SOURCEDIRS ANYFILE HINT_EXT_QT_UI UIFILES)
	if(EXTRA_QT_UI)		
		set(UIFILES ${UIFILES} ${EXTRA_QT_UI})
	endif()
	
	if(UIFILES)
		list(REMOVE_DUPLICATES UIFILES)
		qt4_wrap_ui(GEN_UI_SOURCES ${UIFILES})		
	endif()
	
	message_var(UIFILES)
	message_var(GEN_UI_SOURCES)
#<-ui	
	
	set(GFILES ${GEN_MOC_SOURCES} ${GEN_QRC_SOURCES} ${GEN_UI_SOURCES})
	
	set(TFILES ${TFILES} ${GFILES} ${QRCFILES} ${UIFILES})	
endif()


# <- Генерируемые файлы
#...............................................................................
foreach(t ${TARGET_LIST})
	set(${t}_FILES ${TFILES})
endforeach()
#...............................................................................
# Определения препроцессора ->
set(ALL_DEFINITIONS)

if(PRIVATE_DEFINITIONS)	
	set(ALL_DEFINITIONS ${ALL_DEFINITIONS} ${PRIVATE_DEFINITIONS})
endif()
message_var(PRIVATE_DEFINITIONS)

if(EXPORT_DEFINITION)
	set(ALL_DEFINITIONS ${ALL_DEFINITIONS} ${EXPORT_DEFINITION})
endif()
message_var(EXPORT_DEFINITION)

if((USE_QT) AND (NOT USE_QT_AUTOMOC))
	set(ALL_DEFINITIONS ${ALL_DEFINITIONS} ${DEF_FOR_DISABLE_INCLUDE_MOC})
endif()

set(EXTERNAL_DEFINITIONS)
if(LINK_LIBS)
	#get_subvariables_list(LINK_LIBS CMAKEBIKES_ _USERS_DEFINITIONS EXTERNAL_DEFINITIONS)
	get_required_definitions(LINK_LIBS EXTERNAL_DEFINITIONS)
	if(EXTERNAL_DEFINITIONS)
		list(REMOVE_DUPLICATES EXTERNAL_DEFINITIONS)
		list(REMOVE_ITEM EXTERNAL_DEFINITIONS NO)
		if(EXTERNAL_DEFINITIONS)
			set(ALL_DEFINITIONS ${ALL_DEFINITIONS} ${EXTERNAL_DEFINITIONS})	
		endif()
	endif()
endif()
message_var(EXTERNAL_DEFINITIONS)

if(${CMAKE_VERSION} VERSION_LESS 2.8.12)
	set(CMAKEBIKES_USE_COMPILE_DEFINITIONS_AS_TARGET_PROPERTY)
endif()
if(NOT CMAKEBIKES_USE_COMPILE_DEFINITIONS_AS_TARGET_PROPERTY)
	if(ALL_DEFINITIONS)			
		foreach(d ${ALL_DEFINITIONS})
			add_definitions(-D${d})
		endforeach()
	endif()
endif()
message_var(ALL_DEFINITIONS)
# <- Определения препроцессора 
#...............................................................................
# Создание цели(целей) ->
if(USE_QT)
	set(LINK_LIST ${LINK_LIST} ${QT_LIBRARIES})
endif()

if(VLD_ENABLED)
	set(LINK_LIST ${LINK_LIST} ${VLD_LIBRARIES})
endif()

message_var(TARGET_LIST)

foreach(t ${TARGET_LIST})	
	if(${${t}_TYPE} STREQUAL EXEC)
		add_executable(${t} ${${t}_TYPE_PARAM} ${${t}_FILES})
	elseif(${${t}_TYPE} STREQUAL HLIB)
		add_custom_target(${t} SOURCES ${${t}_FILES})
	else()
		add_library(${t} ${${t}_TYPE_PARAM} ${${t}_FILES})		
	endif()
	set_target_properties(${t} PROPERTIES DEBUG_POSTFIX "_d")		
	if(LINK_LIST)
		target_link_libraries(${t} ${LINK_LIST})		
	endif()
	
endforeach()
# <- Создание цели(целей)
#...............................................................................
# Определения препроцессора (в случае CMAKEBIKES_USE_COMPILE_DEFINITIONS_AS_TARGET_PROPERTY) ->
if(CMAKEBIKES_USE_COMPILE_DEFINITIONS_AS_TARGET_PROPERTY)
	if(ALL_DEFINITIONS)			
		foreach(t ${TARGET_LIST})
			#set_property(TARGET ${t} APPEND PROPERTY COMPILE_DEFINITIONS ${ALL_DEFINITIONS})
			foreach(d ${ALL_DEFINITIONS})
				target_compile_definitions(${t} PRIVATE ${d})
			endforeach()
		endforeach()
	endif()
endif()
# <- Определения препроцессора (в случае CMAKEBIKES_USE_COMPILE_DEFINITIONS_AS_TARGET_PROPERTY)
#...............................................................................
# Позиционно независимый код ->
foreach(t ${TARGET_LIST})	
	get_target_property(targetType ${t} TYPE)
	if(targetType STREQUAL STATIC_LIBRARY)
		set_target_properties(${t} PROPERTIES POSITION_INDEPENDENT_CODE YES)
	endif()
endforeach()
# <- Позиционно независимый код
#...............................................................................
# Окончательное определение внешних каталогов включения ->
if(TARGET_EXISTS)
	set(REQUIRED_INCLUDE_DIRS)
	foreach(t ${TARGET_LIST})
		get_target_property(tinclude ${t} INCLUDE_DIRECTORIES)
		set(${t}_INCLUDED_DIRS ${tinclude})
		message_var(${t}_INCLUDED_DIRS)
		if(tinclude)
			set(REQUIRED_INCLUDE_DIRS ${REQUIRED_INCLUDE_DIRS} ${tinclude})	
		endif()
	endforeach()

	if(REQUIRED_INCLUDE_DIRS)		
		list(REMOVE_DUPLICATES REQUIRED_INCLUDE_DIRS)	
		set(INCLUDE_DIRS ${REQUIRED_INCLUDE_DIRS})
		if(PUBLIC_INCLUDE_DIRS OR PRIVATE_INCLUDE_DIRS)
			list(REMOVE_ITEM REQUIRED_INCLUDE_DIRS ${PUBLIC_INCLUDE_DIRS} ${PRIVATE_INCLUDE_DIRS})	
		endif()
	else()
		set(REQUIRED_INCLUDE_DIRS)
		set(INCLUDE_DIRS)
	endif()
	if(VLD_ENABLED)
		list(REMOVE_ITEM REQUIRED_INCLUDE_DIRS ${VLD_INCLUDE_DIRS})
	endif()
endif()
message_var(REQUIRED_INCLUDE_DIRS)
# <- Окончательное определение внешних каталогов включения 
#...............................................................................
# Определение каталогов включения пользователей ->

set(USERS_INCLUDE_LIBS)
if(NOT LINK_LIBS)
set(LINK_LIBS)
endif()
if(NOT REQUIRED_INCLUDE)
set(REQUIRED_INCLUDE)
endif()
set(DEPENDENCIES_LIBS ${LINK_LIBS} ${REQUIRED_INCLUDE})

if(USERS_INCLUDE)
	set(uid)
	list(REMOVE_DUPLICATES USERS_INCLUDE)
	
	list(FIND USERS_INCLUDE AUTO f)	
	if(NOT (${f} EQUAL -1))			
		set(uid ${uid} ${PUBLIC_INCLUDE_DIRS} ${REQUIRED_INCLUDE_DIRS})		
		set(USERS_INCLUDE_LIBS ${USERS_INCLUDE_LIBS} ${DEPENDENCIES_LIBS} )
	endif()		
	list(FIND USERS_INCLUDE PUBLIC f)
	if(NOT (${f} EQUAL -1))			
		set(uid ${uid} ${PUBLIC_INCLUDE_DIRS})		
	endif()	
	list(FIND USERS_INCLUDE PRIVATE f)
	if(NOT (${f} EQUAL -1))			
		set(uid ${uid} ${PRIVATE_INCLUDE_DIRS})		
	endif()	
	list(FIND USERS_INCLUDE DEPENDENCIES f)
	if(NOT (${f} EQUAL -1))			
		set(uid ${uid} ${REQUIRED_INCLUDE_DIRS})				
		set(USERS_INCLUDE_LIBS ${USERS_INCLUDE_LIBS} ${DEPENDENCIES_LIBS} )
	endif()	
	list(FIND USERS_INCLUDE ADDITIONAL f)
	if(NOT (${f} EQUAL -1))			
		set(uid ${uid} ${ADDITIONAL_INCLUDE_DIRS})		
	endif()	
#	foreach(lib ${DEPENDENCIES_LIBS})
#		list(FIND USERS_INCLUDE ${lib} f)
#		if(NOT (${f} EQUAL -1))
#			set(USERS_INCLUDE_LIBS ${USERS_INCLUDE_LIBS} ${lib})
#			list(REMOVE_ITEM USERS_INCLUDE ${lib})
#		else()
#			list(FIND RE)
#		endif()
#	endforeach()
	list(REMOVE_ITEM USERS_INCLUDE NO AUTO PUBLIC PRIVATE DEPENDENCIES ADDITIONAL)	
	
	foreach(d ${USERS_INCLUDE})
		if(TARGET ${d})
			set(USERS_INCLUDE_LIBS ${USERS_INCLUDE_LIBS} ${d})
		else()			
			list(FIND DEPENDENCIES_LIBS ${d} f)
			if(NOT (${f} EQUAL -1) )
				set(USERS_INCLUDE_LIBS ${USERS_INCLUDE_LIBS} ${d})
			else()
				get_filename_component(p ${d} ABSOLUTE)
				set(uid ${uid} ${p})			
			endif()
		endif()
	endforeach()
	
	if(uid)
		list(REMOVE_DUPLICATES uid)			
		set(USERS_INCLUDE ${uid})
	else()	
		set(USERS_INCLUDE)
	endif()		
	if(USERS_INCLUDE_LIBS)
		list(REMOVE_DUPLICATES USERS_INCLUDE_LIBS)
	endif()
endif()		


message_var(ADDITIONAL_INCLUDE_DIRS)
message_var(USERS_INCLUDE)
# <- Определение каталогов включения пользователей 
#...............................................................................
# Экспорт определений препроцессора ->
if(USERS_DEFINITIONS)
	set(def)
	list(REMOVE_DUPLICATES USERS_DEFINITIONS)
	list(FIND USERS_DEFINITIONS AUTO f)
	if(NOT (${f} EQUAL -1))
		list(REMOVE_ITEM USERS_DEFINITIONS AUTO STATIC_EXPORT)
		set(USERS_DEFINITIONS ${USERS_DEFINITIONS} STATIC_EXPORT)
	endif()
	if(EXPORT_DEFINITION)
		list(FIND USERS_DEFINITIONS STATIC_EXPORT f)
		if(NOT (${f} EQUAL -1))		
			if(${EXPORT_DEFINITION} STREQUAL ${DEF_FOR_STATIC_EXPORT})		
				set(def ${def} ${DEF_FOR_STATIC_EXPORT})
			endif()
		endif()
		list(FIND USERS_DEFINITIONS SHARED_EXPORT f)
		if(NOT (${f} EQUAL -1))
			if(${EXPORT_DEFINITION} STREQUAL ${SHARED_EXPORT})		
				set(def ${def} ${DEF_FOR_SHARED_EXPORT})
			endif()
		endif()
	endif()
	list(FIND USERS_DEFINITIONS PRIVATE f)
	if(NOT (${f} EQUAL -1))
		if(PRIVATE_DEFINITIONS)
			set(def ${def} ${PRIVATE_DEFINITIONS})
		endif()
	endif()
	list(REMOVE_ITEM USERS_DEFINITIONS AUTO STATIC_EXPORT SHARED_EXPORT PRIVATE)
	set(def ${def} ${USERS_DEFINITIONS})
	if(def)
		list(REMOVE_DUPLICATES def)
		set(USERS_DEFINITIONS ${def})
	else()
		set(USERS_DEFINITIONS)
	endif()
else()
set(USERS_DEFINITIONS)
endif()
message_var(USERS_DEFINITIONS)
# <- Экспорт определений препроцессора 
#...............................................................................
# CMakeBikes variables ->
set(CMAKEBIKES_${PROJECT_NAME}_LIB_LIST ${LIB_OUT})
set(CMAKEBIKES_${PROJECT_NAME}_HLIB_LIST ${HLIB_OUT})
set(CMAKEBIKES_${PROJECT_NAME}_EXEC_LIST ${EXEC_OUT})
set(CMAKEBIKES_${PROJECT_NAME}_TARGET_LIST ${TARGET_LIST} ${SUBTARGETS_ALL})
set(CMAKEBIKES_${PROJECT_NAME}_USERS_INCLUDE_DIRS ${USERS_INCLUDE})
set(CMAKEBIKES_${PROJECT_NAME}_USERS_INCLUDE_LIBS ${USERS_INCLUDE_LIBS})
set(CMAKEBIKES_${PROJECT_NAME}_USERS_DEFINITIONS ${USERS_DEFINITIONS})
set(CMAKEBIKES_${PROJECT_NAME}_SUBPROJECTS_LIST ${SUBPROJECTS})
set(CMAKEBIKES_${PROJECT_NAME}_LINK_REQUIRED ${LINK_LIBS})
set(CMAKEBIKES_${PROJECT_NAME}_INCLUDE_REQUIRED ${REQUIRED_INCLUDE})
foreach(t ${LIB_OUT} ${EXEC_OUT} ${HLIB_OUT})
	set(CMAKEBIKES_${t}_TYPE ${${t}_TYPE})
	set(CMAKEBIKES_${t}_REQUIRED_INCLUDE ${BAD_LIBS})
	set(CMAKEBIKES_${t}_USERS_INCLUDE_DIRS ${USERS_INCLUDE})
	set(CMAKEBIKES_${t}_USERS_INCLUDE_LIBS ${USERS_INCLUDE_LIBS})
	set(CMAKEBIKES_${t}_USERS_DEFINITIONS ${USERS_DEFINITIONS})
endforeach()
# <- CMakeBikes variables 
#...............................................................................
# BAD_LIBS ->
set(SUBTARGETS_ALL)
if(SUBPROJECTS_ALL)
	get_subvariables_list(SUBPROJECTS_ALL CMAKEBIKES_ _TARGET_LIST SUBTARGETS_ALL)
endif()
message_var(SUBTARGETS_ALL)
foreach(t ${SUBTARGETS_ALL})
	if(CMAKEBIKES_${t}_REQUIRED_INCLUDE)		
		get_required_include_dirs(CMAKEBIKES_${t}_REQUIRED_INCLUDE rInclude badLibs)
		get_required_definitions(CMAKEBIKES_${t}_REQUIRED_INCLUDE rDef)		
		if(rInclude)
			get_target_property(tinclude ${t} INCLUDE_DIRECTORIES)
			if(tinclude)
				set(tinclude ${tinclude} ${rInclude})
			else()
				set(tinclude ${rInclude})
			endif()
			list(REMOVE_DUPLICATES tinclude)
			set_property(TARGET ${t} PROPERTY INCLUDE_DIRECTORIES ${tinclude})
			message("WARNING: late set property INCLUDE_DIRECTORIES for target ${t} because of the subprojects sequens is incorrect.")
		endif()
		if(rDef)
			get_target_property(tDef ${t} COMPILE_DEFINITIONS)
			if(tDef)
				set(tDef ${tDef} ${rDef})
			else()
				set(tDef ${rDef})
			endif()
			list(REMOVE_DUPLICATES tDef)
			set_property(TARGET ${t} PROPERTY COMPILE_DEFINITIONS ${tDef})
			message("WARNING: late set property COMPILE_DEFINITIONS for target ${t} because of the subprojects sequens is incorrect")
		endif()
		set(CMAKEBIKES_${t}_REQUIRED_INCLUDE ${badLibs})
	endif()
endforeach()
# <- BAD_LIBS
#===============================================================================
#...............................................................................
# Предкомпилированный заголовок ->
if(TARGET_EXISTS)
	get_target_property(DEFINITIONS_FOR_${TARGET_NAME} ${TARGET_NAME} COMPILE_DEFINITIONS)
	message_var(DEFINITIONS_FOR_${TARGET_NAME})
	if(USE_PRECOMPILED_HEADER)
		if(${USE_PRECOMPILED_HEADER} STREQUAL AUTO)
			find_project_files(SOURCEDIRS HINT_PRECOMPILED_HEADER HINT_EXT_HEADERS hs)
			if(hs)
				list(GET hs 0 USE_PRECOMPILED_HEADER)
			else()
				set(USE_PRECOMPILED_HEADER)
			endif()
		endif()
	endif()
	message_var(USE_PRECOMPILED_HEADER)
	if(USE_PRECOMPILED_HEADER)
		include(cotire)
		set_target_properties(${TARGET_NAME} PROPERTIES COTIRE_CXX_PREFIX_HEADER_INIT ${USE_PRECOMPILED_HEADER})
		set_target_properties(${TARGET_NAME} PROPERTIES COTIRE_ADD_UNITY_BUILD false)
		cotire(${TARGET_NAME})
	endif()
endif()
# <- Предкомпилированный заголовок
#...............................................................................
if(USE_QT_AUTOMOC)		
	foreach(t ${TARGET_LIST})
		set_target_properties(${t} PROPERTIES AUTOMOC true)
		#message("set_target_properties(${t} PROPERTIES AUTOMOC true)")
	endforeach()
endif()
#...............................................................................
# Группировка файлов ->
if(SFILES)
	group_files(SFILES ${CMAKE_CURRENT_SOURCE_DIR} NO sources)	
endif()
if(HFILES)
	group_files(HFILES ${CMAKE_CURRENT_SOURCE_DIR} NO headers)	
endif()
if(QRCFILES)
	group_files(QRCFILES ${CMAKE_CURRENT_SOURCE_DIR} NO qrc-resources)
endif()
if(UIFILES)
	group_files(UIFILES ${CMAKE_CURRENT_SOURCE_DIR} NO ui-forms)
endif()
if(GFILES)
	source_group(generated FILES ${GFILES})
endif()
# <- Группировка файлов
#...............................................................................
# Группировка подпроектов ->
if(SUBPROJECTS)
	group_projects(SUBPROJECTS AUTO)
endif()
# <- Группировка подпроектов
#...............................................................................
# install ->
if(USE_INSTALL)		
	if( (${USE_INSTALL} STREQUAL YES) OR (${USE_INSTALL} STREQUAL ON) OR (${USE_INSTALL} STREQUAL TRUE))
		if((NOT (${PROJECT_TYPE} STREQUAL STATIC_LIB)) AND (TARGET ${TARGET_NAME}))
			install(TARGETS ${TARGET_NAME} RUNTIME DESTINATION "./" LIBRARY DESTINATION "./")
		endif()
	elseif(TARGET ${TARGET_NAME})		
		if(NOT (${PROJECT_TYPE} STREQUAL STATIC_LIB))
			install(TARGETS ${TARGET_NAME} RUNTIME DESTINATION "./${USE_INSTALL}" LIBRARY DESTINATION "./${USE_INSTALL}")
		endif()
	elseif(${PROJECT_TYPE} STREQUAL AGGREGATION)
		set(CMAKE_INSTALL_PREFIX "${OUT_ROOT_DIR}/${OUT_INSTALL_DIR}")
	endif()
endif()
# <- install
#...............................................................................
# push up ->
if(IS_SUB_PROJECT)
	set(CMAKEBIKES_TMP_SUBPROJECT_NAME ${PROJECT_NAME} PARENT_SCOPE)
	push_up_project_variables(${PROJECT_NAME})
endif()
# <- push up
#...............................................................................
# Создание графа зависимостей (средствами Graphvis) ->
if(NOT IS_SUB_PROJECT)
	set(dotFile "${CMAKE_BINARY_DIR}/dependence_graph.dot")
	save_dependensies_to_graphthvis_file(${PROJECT_NAME} ${dotFile})
	
	if(EXISTS ${dotFile})
		
		set(out_formats png svg)
		set(cmd)
		set(src)
		foreach(f ${out_formats})
			set(${f}_file ${CMAKE_BINARY_DIR}/dependence_graph.${f})			
			set_property(SOURCE ${${f}_file} PROPERTY GENERATED TRUE)		
			source_group(output FILES ${${f}_file})
			set(cmd ${cmd} COMMAND dot -T${f} ${dotFile} -o ${${f}_file})
			set(src ${src} ${${f}_file})
		endforeach()
		source_group("dot-sources" FILES ${dotFile})
		set(src ${src} ${dotFile})
		add_custom_target(
			GraphvisGenerator
			SOURCES ${src} 
			${cmd}
			)
		set_property(TARGET GraphvisGenerator PROPERTY FOLDER CMakeBikes)
	endif()
endif()
# <- Создание графа зависимостей (средствами Graphvis)
#...............................................................................
If(PRINT_MESSAGES)
	# if(CMAKEBIKES_FIRSTPASSAGE)
		# message("\n<- CMakeBikes stoped for ${PROJECT_NAME} (first passage)")
	# else()
		message("\n<- CMakeBikes stoped for ${PROJECT_NAME}")
	# endif()	
else()
	# if(CMAKEBIKES_FIRSTPASSAGE)
		# message(STATUS "CMakeBikes executed for ${PROJECT_NAME} (first passage)")
	# else()
		message(STATUS "CMakeBikes executed for ${PROJECT_NAME}")
	# endif()
endif()
#...............................................................................
endmacro()
#===============================================================================
