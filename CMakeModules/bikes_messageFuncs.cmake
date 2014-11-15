#===============================================================================
function (message_list MLIST)
	if(PRINT_MESSAGES)
		message(STATUS "\n${MLIST} = {")
		if(${MLIST})
			foreach(m ${${MLIST}})
				message(STATUS "  ${m}")
			endforeach()
		else()
			message(STATUS "  <nothing>")
		endif()
		message(STATUS "  }")
	endif()
endfunction()
#===============================================================================
function(message_var v)
	if(PRINT_MESSAGES)
		if(DEFINED ${v})
			list(LENGTH ${v} _l)			
			if(${_l} GREATER 1)
				message_list(${v})
			else()
				message(STATUS "\n${v} = ${${v}}")
			endif()
		else()
			message(STATUS "\n${v} = <not defined>")
		endif()
	endif()
endfunction()
#===============================================================================
function(br)
	if(PRINT_MESSAGES)
		message("")
	endif()
endfunction()
#===============================================================================
function(message_project_vars in_projectName)
	if(${PROJECT_NAME}_MESSAGES)
		message(STATUS "\n\n--------------------------------------------------------")
		message(STATUS ">>> CMakeBikes variables for ${in_projectName} >>>")
		message_var(CMAKEBIKES_${in_projectName}_EXEC_LIST)
		message_var(CMAKEBIKES_${in_projectName}_LIB_LIST)
		message_var(CMAKEBIKES_${in_projectName}_TARGET_LIST)
		message_var(CMAKEBIKES_${in_projectName}_USERS_INCLUDE_DIRS)
		message_var(CMAKEBIKES_${in_projectName}_USERS_DEFINITIONS)
		foreach(t ${CMAKEBIKES_${in_projectName}_TARGET_LIST})
			message_var(CMAKEBIKES_${t}_REQUIRED_INCLUDE)
			message_var(CMAKEBIKES_${t}_USERS_INCLUDE_DIRS)
			message_var(CMAKEBIKES_${t}_USERS_DEFINITIONS)
		endforeach()
		message(STATUS "\n<<< CMakeBikes variables for ${in_projectName} <<<")
		message(STATUS "--------------------------------------------------------")
	endif()
endfunction()
#===============================================================================

function(message_target_properties in_target)

	set(TARGET_PROPERTIES_LIST
	#<CONFIG>_OUTPUT_NAME
	#<CONFIG>_POSTFIX
	ARCHIVE_OUTPUT_DIRECTORY
	#ARCHIVE_OUTPUT_DIRECTORY_<CONFIG>
	ARCHIVE_OUTPUT_NAME
	#ARCHIVE_OUTPUT_NAME_<CONFIG>
	AUTOMOC
	AUTOMOC_MOC_OPTIONS
	BUILD_WITH_INSTALL_RPATH
	BUNDLE
	BUNDLE_EXTENSION
	COMPILE_DEFINITIONS
	#COMPILE_DEFINITIONS_<CONFIG>
	COMPILE_FLAGS
	DEBUG_POSTFIX
	DEFINE_SYMBOL
	ENABLE_EXPORTS
	EXCLUDE_FROM_ALL
	EchoString
	FOLDER
	FRAMEWORK
	Fortran_FORMAT
	Fortran_MODULE_DIRECTORY
	GENERATOR_FILE_NAME
	GNUtoMS
	HAS_CXX
	IMPLICIT_DEPENDS_INCLUDE_TRANSFORM
	IMPORTED
	IMPORTED_CONFIGURATIONS
	IMPORTED_IMPLIB
	#IMPORTED_IMPLIB_<CONFIG>
	IMPORTED_LINK_DEPENDENT_LIBRARIES
	#IMPORTED_LINK_DEPENDENT_LIBRARIES_<CONFIG>
	IMPORTED_LINK_INTERFACE_LANGUAGES
	#IMPORTED_LINK_INTERFACE_LANGUAGES_<CONFIG>
	IMPORTED_LINK_INTERFACE_LIBRARIES
	#IMPORTED_LINK_INTERFACE_LIBRARIES_<CONFIG>
	IMPORTED_LINK_INTERFACE_MULTIPLICITY
	#IMPORTED_LINK_INTERFACE_MULTIPLICITY_<CONFIG>
	IMPORTED_LOCATION
	#IMPORTED_LOCATION_<CONFIG>
	IMPORTED_NO_SONAME
	#IMPORTED_NO_SONAME_<CONFIG>
	IMPORTED_SONAME
	#IMPORTED_SONAME_<CONFIG>
	IMPORT_PREFIX
	IMPORT_SUFFIX
	INCLUDE_DIRECTORIES
	INSTALL_NAME_DIR
	INSTALL_RPATH
	INSTALL_RPATH_USE_LINK_PATH
	INTERPROCEDURAL_OPTIMIZATION
	#INTERPROCEDURAL_OPTIMIZATION_<CONFIG>
	LABELS
	LIBRARY_OUTPUT_DIRECTORY
	#LIBRARY_OUTPUT_DIRECTORY_<CONFIG>
	LIBRARY_OUTPUT_NAME
	#LIBRARY_OUTPUT_NAME_<CONFIG>
	LINKER_LANGUAGE
	LINK_DEPENDS
	LINK_FLAGS
	#LINK_FLAGS_<CONFIG>
	LINK_INTERFACE_LIBRARIES
	#LINK_INTERFACE_LIBRARIES_<CONFIG>
	LINK_INTERFACE_MULTIPLICITY
	#LINK_INTERFACE_MULTIPLICITY_<CONFIG>
	LINK_SEARCH_END_STATIC
	LINK_SEARCH_START_STATIC
	LOCATION
	#LOCATION_<CONFIG>
	MACOSX_BUNDLE
	MACOSX_BUNDLE_INFO_PLIST
	MACOSX_FRAMEWORK_INFO_PLIST
	#MAP_IMPORTED_CONFIG_<CONFIG>
	NO_SONAME
	OSX_ARCHITECTURES
	#OSX_ARCHITECTURES_<CONFIG>
	OUTPUT_NAME
	#OUTPUT_NAME_<CONFIG>
	PDB_NAME
	#PDB_NAME_<CONFIG>
	PDB_OUTPUT_DIRECTORY
	#PDB_OUTPUT_DIRECTORY_<CONFIG>
	POSITION_INDEPENDENT_CODE
	POST_INSTALL_SCRIPT
	PREFIX
	PRE_INSTALL_SCRIPT
	PRIVATE_HEADER
	PROJECT_LABEL
	PUBLIC_HEADER
	RESOURCE
	RULE_LAUNCH_COMPILE
	RULE_LAUNCH_CUSTOM
	RULE_LAUNCH_LINK
	RUNTIME_OUTPUT_DIRECTORY
	#RUNTIME_OUTPUT_DIRECTORY_<CONFIG>
	RUNTIME_OUTPUT_NAME
	#RUNTIME_OUTPUT_NAME_<CONFIG>
	SKIP_BUILD_RPATH
	SOURCES
	SOVERSION
	STATIC_LIBRARY_FLAGS
	#STATIC_LIBRARY_FLAGS_<CONFIG>
	SUFFIX
	TYPE
	VERSION
	VS_DOTNET_REFERENCES
	#VS_GLOBAL_<variable>
	VS_GLOBAL_KEYWORD
	VS_GLOBAL_PROJECT_TYPES
	VS_KEYWORD
	VS_SCC_AUXPATH
	VS_SCC_LOCALPATH
	VS_SCC_PROJECTNAME
	VS_SCC_PROVIDER
	VS_WINRT_EXTENSIONS
	VS_WINRT_REFERENCES
	WIN32_EXECUTABLE
	#XCODE_ATTRIBUTE_<an-attribute>
	)


message("\n\n >>> Properties for target [${in_target}] >>>")
	foreach(tp ${TARGET_PROPERTIES_LIST})
		get_target_property(${tp} ${in_target} ${tp})
		if(${tp})
			message_var(${tp})
		endif()
	endforeach()
message("\n <<< Properties for target [${in_target}] <<<")
endfunction()