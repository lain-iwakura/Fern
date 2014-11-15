# CMakeBikesLists (необходимая подпись)
#-------------------------------------------------------------------------------
cmake_minimum_required (VERSION 2.8.9)
#-------------------------------------------------------------------------------
# Включение и инициализация CMakeBikes ->
CMakeBikes_init()
# <- Включение и инициализация CMakeBikes
#-------------------------------------------------------------------------------
# Опции ->

set(PROJECT_NAME			Fern) # AUTO|<THE_NAME_OF_PROJECT>

set(PROJECT_TYPE			AUTO) # AUTO|EXECUTABLE|SHARED_LIB|STATIC_LIB|SHARED_OR_STATIC_LIB|STATIC_OR_SHARED_LIB|HEADERS_LIB|AGGREGATION

set(REQUIRED_LIBS 			AUTO) # NO|[AUTO][<REQUIRED_LIBS_LIST>]

set(REQUIRED_INCLUDE		NO)   # NO|<REQUIRED_TARGETS_LIST>

set(ADDITIONAL_INCLUDE_DIRS NO)   # NO|<INCLUDE_DIRS_LIST>

set(PRIVATE_DEFINITIONS 	NO)	  # NO|<DEFINITIONS_LIST>

set(USERS_INCLUDE 		    AUTO) # NO|[AUTO][PUBLIC][PRIVATE][DEPENDENCIES][ADDITIONAL][<INCLUDE_TARGETS_LIST>][<INCLUDE_DIRS_LIST>]

set(USERS_DEFINITIONS 		AUTO) # NO|[AUTO][STATIC_EXPORT][SHARED_EXPORT][PRIVATE][<DEFINITIONS_LIST>]

set(USE_PRECOMPILED_HEADER 	AUTO) # NO|AUTO|<HEADER_PATH>

set(USE_BOOST				OFF)  # ON|OFF

set(USE_QT					OFF)  # ON|OFF|[ON][AUTOMOC][CORE][MAIN][GUI][OPENGL][SVG][XML][SQL][NETWORK][3SUPPORT][WEBKIT][HELP][TEST]

set(USE_VLD					ON)   # ON|OFF

set(USE_INSTALL				OFF)  # ON|OFF|<INSTALL_PATH>

set(OUT_BIN_PREFIX			NO)   # NO|<BIN_RELATIVE_PATH>

# <- Опции
#-------------------------------------------------------------------------------
# Создание целей ->
CMakeBikes_run()
# <- Создание целей
#-------------------------------------------------------------------------------