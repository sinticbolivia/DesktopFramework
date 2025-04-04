project('libSinticBolivia', 'vala', 'c', version: '1.0.2')
# LIBSOUP
dsoup = dependency('libsoup-3.0', required: false)
if dsoup.found()
	message('LIBSOUP 3 FOUND')
else
	dsoup = dependency('libsoup-2.4', version: '>=2.64.2')
	add_project_arguments(['-D', '__SOUP_VERSION_2_70__'], language: 'vala')
	message('LIBSOUP 2 FOUND')
endif

add_project_arguments(['-DGETTEXT_PACKAGE'], language: 'c')
dependencies = [
	dependency('glib-2.0'),
	dependency('gobject-2.0'),
	dependency('gmodule-2.0'),
	dependency('gee-0.8'),
	dependency('json-glib-1.0'),
	dependency('libxml-2.0'),
	dependency('sqlite3'),
	# meson.get_compiler('vala').find_library('mysql'),
	dependency('mysql'),
	dependency('libpq'),
	dsoup,
]
include_dir = [
  './ccode'
]
sources = [
  'ccode/cpuid.c',
  'ccode/smtp.c',
  'ccode/smtp_client.c',
  'classes/class.config.vala',
  'classes/class.datetime.vala',
  'classes/class.db-object.vala',
  'classes/class.factory.vala',
  'classes/class.file-helper.vala',
  'classes/class.meta.vala',
  'classes/class.os.vala',
  'classes/class.parameter.vala',
  'classes/class.utils.vala',
  'classes/Event.vala',
  'classes/ISBModule.vala',
  'classes/ISBRestModule.vala',
  'classes/Observable.vala',
  'classes/Observer.vala',
  'classes/RestController.vala',
  'classes/RestHandler.vala',
  'classes/RestResponse.vala',
  'classes/RestResponseJson.vala',
  'classes/RestServer.vala',
  'classes/SBCallbackArgs.vala',
  'classes/SBCollection.vala',
  'classes/SBException.vala',
  'classes/SBGlobals.vala',
  'classes/SBModule.vala',
  'classes/SBObject.vala',
  'classes/SBRequest.vala',
  'classes/SBResponse.vala',
  'classes/SBSerializable.vala',
  'classes/SBSmtpClient.vala',
  'classes/SBSmtpConfig.vala',
  'classes/SBText.vala',
  'classes/SBWebRoute.vala',
  'Database/database.vala',
  'Database/Entity.vala',
  'Database/SQLite.vala',
  'Database/MySQL.vala',
  'Database/Postgres.vala',
  'Database/SBBelongsTo.vala',
  'Database/SBDatabaseException.vala',
  'Database/SBDBCell.vala',
  'Database/SBDBColumn.vala',
  'Database/SBDBQuery.vala',
  'Database/SBDBRow.vala',
  'Database/SBDBTable.vala',
  'Database/SBHasMany.vala',
  'Database/SBHasOne.vala',
]
libsinticbolivia = shared_library(
	'SinticBolivia',
	sources,
	dependencies: dependencies,
	include_directories : include_directories(include_dir),
	#install: true,
	#install_dir: install_dir,
)
libsinticbolivia_dep = declare_dependency(
	include_directories : include_directories(include_dir),
	link_with : libsinticbolivia
)
api = executable('api',
  ['tests/api-rest.vala'],
  dependencies: [
    dependency('glib-2.0'),
  	dependency('gobject-2.0'),
  	dependency('gmodule-2.0'),
		dependency('gee-0.8'),
		dependency('json-glib-1.0'),
		dependency('libxml-2.0'),
		dependency('sqlite3'),
		dependency('mysql'),
		dependency('libpq'),
		dsoup,
		libsinticbolivia_dep,
  ]
)
