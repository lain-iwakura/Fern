#ifndef INCLUDE_FERN_EXPORT_H
#define INCLUDE_FERN_EXPORT_H

#ifdef _MSC_VER
#	define FERN_DECL_EXPORT __declspec(dllexport)
#	define FERN_DECL_EXPORT __declspec(dllimport)
#else
#	define FERN_DECL_EXPORT  // or(?) __attribute__((visibility("default"))) 
#	define FERN_DECL_EXPORT  // or(?) __attribute__((visibility("default"))) 
#endif

#if defined(FERN_SHAREDLIB)
#	define FERN_EXPORT	BFERN_DECL_EXPORT
#elif defined(FERN_STATICLIB)
#	define FERN_EXPORT
#else
#	define FERN_EXPORT FERN_DECL_IMPORT
#endif

#endif // <- INCLUDE_FERN_EXPORT_H
