#bikes_useQt
#===============================================================================
macro(include_qt)
	if(USE_QT)

		list(REMOVE_DUPLICATES USE_QT)
		list(FIND USE_QT ON f)
		if(${f} EQUAL -1)
			list(FIND USE_QT CORE f)
			if(${f} EQUAL -1)
				set(QT_DONT_USE_QTCORE ON)
			else()
				set(QT_DONT_USE_QTCORE OFF)
			endif()
			list(FIND USE_QT GUI f)
			if(${f} EQUAL -1)
				set(QT_DONT_USE_QTGUI ON)
			else()
				set(QT_DONT_USE_QTGUI OFF)
			endif()
			list(FIND USE_QT MAIN f)
			if(${f} EQUAL -1)
				set(QT_USE_QTMAIN OFF)
			else()
				set(QT_USE_QTMAIN ON)
			endif()
		else()
			set(QT_DONT_USE_QTCORE OFF)
			set(QT_DONT_USE_QTGUI OFF)
			set(QT_USE_QTMAIN ON)
		endif()
		list(FIND USE_QT AUTOMOC f)
		if(NOT (${f} EQUAL -1) )
			set(USE_QT_AUTOMOC ON)
		endif()
		list(REMOVE_ITEM USE_QT ON OFF CORE MAIN GUI AUTOMOC)

		message_var(QT_DONT_USE_QTCORE)
		message_var(QT_DONT_USE_QTGUI)
		message_var(QT_USE_QTMAIN)

		foreach(q ${USE_QT})
			set(QT_USE_QT${q} ON)
			message_var(QT_USE_QT${q})
		endforeach()

		find_package(Qt4 REQUIRED)
		include(${QT_USE_FILE})
		
		
		# Костыль устанавливающий COMPILE_DEFINITIONS для ${CMAKE_CURRENT_SOURCE_DIR} ->
		
		set(dirProperties 	COMPILE_DEFINITIONS 
							COMPILE_DEFINITIONS_DEBUG 
							COMPILE_DEFINITIONS_RELEASE 
							COMPILE_DEFINITIONS_RELWITHDEBINFO
							COMPILE_DEFINITIONS_MINSIZEREL)	
							
		foreach(prop ${dirProperties})
			get_property(dir_prop DIRECTORY PROPERTY ${prop})
			get_property(curdir_prop DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY ${prop})
			if(dir_prop)
				set(curdir_prop ${curdir_prop} ${dir_prop})			
				list(REMOVE_DUPLICATES curdir_prop)			
				set_property(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY ${prop} ${curdir_prop})
			endif()
		endforeach()			
		
		# <- Костыль устанавливающий COMPILE_DEFINITIONS для ${CMAKE_CURRENT_SOURCE_DIR}

		set(USE_QT ON)
	endif()
endmacro()
#===============================================================================
macro(find_moc_files in_shfilesList out_mocGeneratedSources)
	set(words Q_OBJECT)
	find_files_with_words(${in_shfilesList} words MFILES)
	if(MFILES)
		CMAKEBIKES_QT4_WRAP_CPP(${OUT_EXT_MOC} MOC_SOURCES ${MFILES})
		set(${out_mocGeneratedSources} ${MOC_SOURCES})
	else()
		set(${out_mocGeneratedSources})
	endif()
endmacro()
#===============================================================================
macro(find_qrc_files in_path_list out_qrcFiles out_qrcGeneratedSources)
	find_project_files(${in_path_list} ANYFILE HINT_EXT_QT_RESOURCES QRFILES)
	if(QRFILES)
		qt4_add_resources(QR_SOURCES ${QRFILES})
		set(${out_qrcFiles} ${QRFILES} )
		set(${out_qrcGeneratedSources} ${QR_SOURCES} )
	else()
		set(${out_qrcFiles} )
		set(${out_qrcGeneratedSources} )
	endif()
endmacro()
#===============================================================================
macro(CMAKEBIKES_QT4_WRAP_CPP in_ext out_files )
	if(${CMAKE_VERSION} VERSION_LESS 2.8.12)
		# get include dirs
		QT4_GET_MOC_FLAGS(moc_flags)
		QT4_EXTRACT_OPTIONS(moc_files moc_options ${ARGN})
		foreach (it ${moc_files})
			get_filename_component(it ${it} ABSOLUTE)
			QT4_MAKE_OUTPUT_FILE(${it} moc_ ${in_ext} outfile)
			QT4_CREATE_MOC_COMMAND(${it} ${outfile} "${moc_flags}" "${moc_options}")
			set(${out_files} ${${out_files}} ${outfile})
		endforeach()
	else()
		# get include dirs
		QT4_GET_MOC_FLAGS(moc_flags)
		QT4_EXTRACT_OPTIONS(moc_files moc_options moc_target ${ARGN})
		foreach (it ${moc_files})
			get_filename_component(it ${it} ABSOLUTE)
			QT4_MAKE_OUTPUT_FILE(${it} moc_ ${in_ext} outfile)
			QT4_CREATE_MOC_COMMAND(${it} ${outfile} "${moc_flags}" "${moc_options}" "${moc_target}")
			set(${out_files} ${${out_files}} ${outfile})
		endforeach()
	endif()
endmacro ()
#===============================================================================

