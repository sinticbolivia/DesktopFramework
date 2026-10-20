project('libSinticBolivia', 'vala', 'c', version: '1.0.2',
  default_options: [
    'warning_level=1',
    'buildtype=debugoptimized',
    'c_std=gnu11'
  ]
)
# LIBSOUP
dsoup = dependency('libsoup-3.0', required: false)
if dsoup.found()
	message('LIBSOUP 3 FOUND')
else
	dsoup = dependency('libsoup-2.4', version: '>=2.64.2')
	add_project_arguments(['-D', '__SOUP_VERSION_2_70__'], language: 'vala')
	message('LIBSOUP 2 FOUND')
endif
mysql = dependency('mysql', required: false)
if not mysql.found()
  mysql = dependency('mysqlclient', required: false)
endif
if not mysql.found()
  mysql = dependency('mariadb', required: false)
endif
if not mysql.found()
  error('Unable to find mysql client library')
endif

vapi_dir = meson.current_source_dir() + '/vapi'
add_project_arguments([
  '-DGETTEXT_PACKAGE',
  #'-DCURL_NO_OLDIES'
], language: 'c')
add_project_arguments(['--vapidir', vapi_dir], language: 'vala')

dependencies = [
	dependency('glib-2.0'),
	dependency('gobject-2.0'),
	dependency('gmodule-2.0'),
	dependency('gee-0.8'),
	dependency('json-glib-1.0'),
	dependency('libxml-2.0'),
	dependency('sqlite3'),
	# meson.get_compiler('vala').find_library('mysql'),
	dependency('libcurl'),
	meson.get_compiler('c').find_library('curl'),
	mysql,
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
  'classes/EmailChecker.vala',
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
		mysql,
		dependency('libpq'),
		dsoup,
		#dependency('libcurl'),
		# meson.get_compiler('vala').find_library('libcurl', dirs: vapi_dir),
    #meson.get_compiler('c').find_library('curl'),
		libsinticbolivia_dep,
  ]
)
executable('imap',
  ['tests/test-imap.vala'],
  dependencies: [
    dependency('glib-2.0'),
  	dependency('gobject-2.0'),
  	dependency('gmodule-2.0'),
		dependency('gee-0.8'),
		dependency('json-glib-1.0'),
		dependency('libxml-2.0'),
		dependency('sqlite3'),
		mysql,
		dependency('libpq'),
		dsoup,
		#dependency('libcurl'),
		# meson.get_compiler('vala').find_library('libcurl', dirs: vapi_dir),
    #meson.get_compiler('c').find_library('curl'),
		libsinticbolivia_dep,
  ]
)
