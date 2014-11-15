# bikes_dependenciesAnalysis.cmake
#===============================================================================
function(check_aliases_for_dependencies in_objectsList)
	set(objs ${${in_objectsList}})
	foreach(pi ${objs})		
		if(CMAKEBIKES_${pi}_ALIASES)
		list(REMOVE_ITEM CMAKEBIKES_${pi}_ALIASES ${pi})
			foreach(pj ${objs})								
				if(CMAKEBIKES_${pj}_DEPENDENCIES)					
					list_replace_all(CMAKEBIKES_${pj}_DEPENDENCIES CMAKEBIKES_${pi}_ALIASES ${pi})
					list(REMOVE_DUPLICATES CMAKEBIKES_${pj}_DEPENDENCIES)				
					list(REMOVE_ITEM CMAKEBIKES_${pj}_DEPENDENCIES ${pj})
				endif()
			endforeach()
		endif()
	endforeach()
	
	foreach(pi ${objs})
		push_up(CMAKEBIKES_${pi}_DEPENDENCIES)
	endforeach()
endfunction()
#===============================================================================
function(get_dependencies_sequence  in_objectsList out_objectsDependenciesSequence)
	set(objs ${${in_objectsList}})	
	if(NOT objs)
		return()
	endif()
	
	# подготовка ->
		set(seq)
		set(deps)
		set(src)
		set(roots)
		set(smpls)
				
		# локализация объектов ->
		foreach(o ${objs})
			if(CMAKEBIKES_${o}_LOCATIONTYPE)
				if(${CMAKEBIKES_${o}_LOCATIONTYPE} STREQUAL DEPENDENCIES)
					set(deps ${deps} ${o})
				elseif(${CMAKEBIKES_${o}_LOCATIONTYPE} STREQUAL SOURCES)
					set(src ${src} ${o})
				elseif(${CMAKEBIKES_${o}_LOCATIONTYPE} STREQUAL ROOT)
					set(roots ${roots} ${o})
				elseif(${CMAKEBIKES_${o}_LOCATIONTYPE} STREQUAL SAMPLES)
					set(smpls ${smpls} ${o})
				endif()
			endif()
		endforeach()
		# <- локализация объектов
			 
		# простановка зависимостей по умолчанию ->
		foreach(o ${objs})
			if(CMAKEBIKES_${o}_DEPENDENCIES)
				list(FIND CMAKEBIKES_${o}_DEPENDENCIES AUTO f)
				if(NOT (${f} EQUAL -1))
					set(CMAKEBIKES_${o}_DEPENDENCIES ${CMAKEBIKES_${o}_DEPENDENCIES} ${deps})
					if(CMAKEBIKES_${o}_LOCATIONTYPE STREQUAL SAMPLES)
						set(CMAKEBIKES_${o}_DEPENDENCIES ${CMAKEBIKES_${o}_DEPENDENCIES} ${src} ${roots} )
					endif()
				endif()				
			endif()
		endforeach()
		# <- простановка зависимостей по умолчанию
		
		check_aliases_for_dependencies(objs)	# замена синонимов на основные имена
		
		foreach(o ${objs})
			if(CMAKEBIKES_${o}_DEPENDENCIES)
				list(REMOVE_DUPLICATES CMAKEBIKES_${o}_DEPENDENCIES)
				list(REMOVE_ITEM CMAKEBIKES_${o}_DEPENDENCIES ${o} AUTO)
			endif()
			set(dpn_${o} 0)
		endforeach()	
		
	# <- подготовка
	
	
	# простановка подчиненности проектов и подсчет зависимостей ->
	foreach(o ${objs})
		if(CMAKEBIKES_${o}_DEPENDENCIES)
			foreach(d ${CMAKEBIKES_${o}_DEPENDENCIES})
				set(CMAKEBIKES_${d}_SLAVES ${CMAKEBIKES_${d}_SLAVES} ${o})
			endforeach()
			list(LENGTH CMAKEBIKES_${o}_DEPENDENCIES dpn_${o})
		else()
			set(dpn_${o} 0)
		endif()
	endforeach()
	# <- простановка подчиненности проектов и подсчет зависимостей

	# сортировка (поиск последовательности подключения) ->
	while(objs)
	
		get_subvariables_list(objs dpn_ NO dpns)	
		find_min_value(dpns min_dpn)		
			
		set(robjs)
		foreach(o ${objs})
			if(${dpn_${o}} EQUAL ${min_dpn})				
				set(seq ${seq} ${o})
				set(robjs ${robjs} ${o})
			endif()
		endforeach()
				
		foreach(o ${robjs})
			foreach(s ${CMAKEBIKES_${o}_SLAVES})
				decrement(dpn_${s})
			endforeach()
		endforeach()
		
		list(REMOVE_ITEM objs ${robjs})
		if(objs)
			list(LENGTH objs lobjs)
			if(${lobjs} EQUAL 0)
				set(objs)
			endif()
		endif()
	endwhile()	
	# <- сортировка (поиск последовательности подключения)

	set(${out_objectsDependenciesSequence} ${seq} PARENT_SCOPE)
endfunction()
#===============================================================================
function(save_dependensies_to_graphthvis_file in_projectName in_filePath)
	set(code)
	set(pcode)
	project_to_graphvis(${in_projectName} pcode)	
	add_line(code "digraph G {")
	add_line(code "label=\"Dependence graph for ${in_projectName}\";")
	#add_line(code "nodesep=1;")
	add_line(code "compound=true;")
	add_line(code "edge[minlen=2.0];")
	add_line(code "${pcode}")
	add_line(code "}")	
	file(WRITE ${in_filePath} "${code}")
endfunction()
#===============================================================================
function(target_to_graphvis in_target out_dotCode)
	set(str)
	if(TARGET ${in_target})
		get_target_property(ty ${in_target} TYPE)
		get_target_property(ty ${in_target} TYPE)
		
		set(STATIC_LIBRARY_shape box)		
		set(MODULE_LIBRARY_shape Msquare)
		set(SHARED_LIBRARY_shape component)
		set(EXECUTABLE_shape box3d)			
		set(shape ${${ty}_shape})		
		if(NOT shape)			
			set(HLIB)
			message_var(CMAKEBIKES_${t}_TYPE)
			if(CMAKEBIKES_${t}_TYPE STREQUAL HLIB)
				set(shape note)
			else()
				set(shape ellipse)
			endif()
		endif()
		
		add_line(str "${in_target}[shape=${shape}];")
	else()
		add_line(str "${in_target}[style=dotted, shape=ellipse];")
	endif()
	set(${out_dotCode} "${str}" PARENT_SCOPE)
endfunction()
#===============================================================================
function(project_to_graphvis in_projectName out_dotCode)
	
	# Проект ->
	set(p ${in_projectName})
	

	
	# Личные цели ->
	set(tgs ${CMAKEBIKES_${p}_EXEC_LIST} ${CMAKEBIKES_${p}_LIB_LIST} ${CMAKEBIKES_${p}_HLIB_LIST})		
	set(tgs_code)
	set(dep_code)
	if(tgs)
		list(LENGTH tgs ltgs)
		foreach(t ${tgs})
			target_to_graphvis(${t} t_code)
			add_line(tgs_code "${t_code}")
			# Зависимости ->
			foreach(lnk ${CMAKEBIKES_${p}_LINK_REQUIRED})
				add_line(dep_code "${lnk} -> ${t};")
			endforeach()
			foreach(inc ${CMAKEBIKES_${p}_INCLUDE_REQUIRED})
				if(TARGET ${inc})
					add_line(dep_code "${inc} -> ${t}[style=dotted];")
				elseif(${inc}_SOURCE_DIR)
					add_line(dep_code "${inc} -> ${t}[style=dotted, ltail=cluster_${inc}];")
				endif()
			endforeach()
			# <- Зависимости
		endforeach()
	else()
		set(ltgs 0)
		add_line(tgs_code "${p}[label=\" \", style=invis];")
	endif()
	# <- Личные цели 
	
	# Индекс ->
	set(pind)
	if(CMAKEBIKES_${p}_INDEX)
		if(CMAKEBIKES_PARENT_INDEX)
			set(pind "${CMAKEBIKES_PARENT_INDEX}.${CMAKEBIKES_${p}_INDEX}")
		else()
			set(pind "${CMAKEBIKES_${p}_INDEX}")
		endif()		
	endif()
	set(CMAKEBIKES_PARENT_INDEX ${pind})
	# <- Индекс
	
		
	# Подпроекты ->
	set(sbps ${CMAKEBIKES_${p}_SUBPROJECTS_LIST})
	set(sbps_code)
	set(i 1)	
	foreach(sbp ${sbps})
		#set(CMAKEBIKES_${sbp}_INDEX ${i})
		project_to_graphvis(${sbp} sbp_code)
		add_line(sbps_code "${sbp_code}")		
		increment(i)
	endforeach()
	# <- Подпроекты

	
	# Проект ->
	set(start_code)
	set(end_code)
	
	set(noCluster)
	if((NOT sbps_code) AND (${ltgs} EQUAL 1))
		if(${p} STREQUAL ${tgs})
			set(noCluster ON)
		endif()
	endif()
	
	if(noCluster)
		if(pind)
			add_line(start_code "${p}[label=\"${p} [${pind}]\"];")
		endif()
	else()
		add_line(start_code "subgraph cluster_${p} {")
		if(pind)
			add_line(start_code "label=\"${p} [${pind}]\";")
		else()
			add_line(start_code "label=\"${p}\";")
		endif()
		add_line(start_code "style=dashed;")
		add_line(end_code "}")
	endif()
	# <- Проект

	
	set(code)
	add_line(code "${start_code}")
	add_line(code "${tgs_code}")
	add_line(code "${dep_code}")
	add_line(code "${sbps_code}")
	add_line(code "${end_code}")
	
	set(${out_dotCode} "${code}" PARENT_SCOPE)
endfunction()
#===============================================================================
