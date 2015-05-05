/* GtkSinticBolivia.h generated by valac 0.24.0, the Vala compiler, do not modify */


#ifndef __GTKSINTICBOLIVIA_H__
#define __GTKSINTICBOLIVIA_H__

#include <glib.h>
#include <SinticBolivia.h>
#include <stdlib.h>
#include <string.h>
#include <float.h>
#include <math.h>
#include <gio/gio.h>
#include <gtk/gtk.h>
#include <gdk-pixbuf/gdk-pixbuf.h>
#include <gee.h>
#include <glib-object.h>
#include <pango/pango.h>
#include <cairo.h>

G_BEGIN_DECLS


#define SINTIC_BOLIVIA_GTK_TYPE_SB_GTK_MODULE (sintic_bolivia_gtk_sb_gtk_module_get_type ())
#define SINTIC_BOLIVIA_GTK_SB_GTK_MODULE(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SINTIC_BOLIVIA_GTK_TYPE_SB_GTK_MODULE, SinticBoliviaGtkSBGtkModule))
#define SINTIC_BOLIVIA_GTK_SB_GTK_MODULE_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), SINTIC_BOLIVIA_GTK_TYPE_SB_GTK_MODULE, SinticBoliviaGtkSBGtkModuleClass))
#define SINTIC_BOLIVIA_GTK_IS_SB_GTK_MODULE(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SINTIC_BOLIVIA_GTK_TYPE_SB_GTK_MODULE))
#define SINTIC_BOLIVIA_GTK_IS_SB_GTK_MODULE_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), SINTIC_BOLIVIA_GTK_TYPE_SB_GTK_MODULE))
#define SINTIC_BOLIVIA_GTK_SB_GTK_MODULE_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), SINTIC_BOLIVIA_GTK_TYPE_SB_GTK_MODULE, SinticBoliviaGtkSBGtkModuleClass))

typedef struct _SinticBoliviaGtkSBGtkModule SinticBoliviaGtkSBGtkModule;
typedef struct _SinticBoliviaGtkSBGtkModuleClass SinticBoliviaGtkSBGtkModuleClass;
typedef struct _SinticBoliviaGtkSBGtkModulePrivate SinticBoliviaGtkSBGtkModulePrivate;

#define SINTIC_BOLIVIA_GTK_TYPE_SB_NOTEBOOK (sintic_bolivia_gtk_sb_notebook_get_type ())
#define SINTIC_BOLIVIA_GTK_SB_NOTEBOOK(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SINTIC_BOLIVIA_GTK_TYPE_SB_NOTEBOOK, SinticBoliviaGtkSBNotebook))
#define SINTIC_BOLIVIA_GTK_SB_NOTEBOOK_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), SINTIC_BOLIVIA_GTK_TYPE_SB_NOTEBOOK, SinticBoliviaGtkSBNotebookClass))
#define SINTIC_BOLIVIA_GTK_IS_SB_NOTEBOOK(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SINTIC_BOLIVIA_GTK_TYPE_SB_NOTEBOOK))
#define SINTIC_BOLIVIA_GTK_IS_SB_NOTEBOOK_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), SINTIC_BOLIVIA_GTK_TYPE_SB_NOTEBOOK))
#define SINTIC_BOLIVIA_GTK_SB_NOTEBOOK_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), SINTIC_BOLIVIA_GTK_TYPE_SB_NOTEBOOK, SinticBoliviaGtkSBNotebookClass))

typedef struct _SinticBoliviaGtkSBNotebook SinticBoliviaGtkSBNotebook;
typedef struct _SinticBoliviaGtkSBNotebookClass SinticBoliviaGtkSBNotebookClass;
typedef struct _SinticBoliviaGtkSBNotebookPrivate SinticBoliviaGtkSBNotebookPrivate;

#define SINTIC_BOLIVIA_GTK_TYPE_SB_DASHBOARD (sintic_bolivia_gtk_sb_dashboard_get_type ())
#define SINTIC_BOLIVIA_GTK_SB_DASHBOARD(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SINTIC_BOLIVIA_GTK_TYPE_SB_DASHBOARD, SinticBoliviaGtkSBDashboard))
#define SINTIC_BOLIVIA_GTK_SB_DASHBOARD_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), SINTIC_BOLIVIA_GTK_TYPE_SB_DASHBOARD, SinticBoliviaGtkSBDashboardClass))
#define SINTIC_BOLIVIA_GTK_IS_SB_DASHBOARD(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SINTIC_BOLIVIA_GTK_TYPE_SB_DASHBOARD))
#define SINTIC_BOLIVIA_GTK_IS_SB_DASHBOARD_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), SINTIC_BOLIVIA_GTK_TYPE_SB_DASHBOARD))
#define SINTIC_BOLIVIA_GTK_SB_DASHBOARD_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), SINTIC_BOLIVIA_GTK_TYPE_SB_DASHBOARD, SinticBoliviaGtkSBDashboardClass))

typedef struct _SinticBoliviaGtkSBDashboard SinticBoliviaGtkSBDashboard;
typedef struct _SinticBoliviaGtkSBDashboardClass SinticBoliviaGtkSBDashboardClass;
typedef struct _SinticBoliviaGtkSBDashboardPrivate SinticBoliviaGtkSBDashboardPrivate;

#define SINTIC_BOLIVIA_GTK_TYPE_SB_FIXED (sintic_bolivia_gtk_sb_fixed_get_type ())
#define SINTIC_BOLIVIA_GTK_SB_FIXED(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SINTIC_BOLIVIA_GTK_TYPE_SB_FIXED, SinticBoliviaGtkSBFixed))
#define SINTIC_BOLIVIA_GTK_SB_FIXED_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), SINTIC_BOLIVIA_GTK_TYPE_SB_FIXED, SinticBoliviaGtkSBFixedClass))
#define SINTIC_BOLIVIA_GTK_IS_SB_FIXED(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SINTIC_BOLIVIA_GTK_TYPE_SB_FIXED))
#define SINTIC_BOLIVIA_GTK_IS_SB_FIXED_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), SINTIC_BOLIVIA_GTK_TYPE_SB_FIXED))
#define SINTIC_BOLIVIA_GTK_SB_FIXED_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), SINTIC_BOLIVIA_GTK_TYPE_SB_FIXED, SinticBoliviaGtkSBFixedClass))

typedef struct _SinticBoliviaGtkSBFixed SinticBoliviaGtkSBFixed;
typedef struct _SinticBoliviaGtkSBFixedClass SinticBoliviaGtkSBFixedClass;
typedef struct _SinticBoliviaGtkSBFixedPrivate SinticBoliviaGtkSBFixedPrivate;

#define SINTIC_BOLIVIA_GTK_TYPE_INFO_DIALOG (sintic_bolivia_gtk_info_dialog_get_type ())
#define SINTIC_BOLIVIA_GTK_INFO_DIALOG(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SINTIC_BOLIVIA_GTK_TYPE_INFO_DIALOG, SinticBoliviaGtkInfoDialog))
#define SINTIC_BOLIVIA_GTK_INFO_DIALOG_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), SINTIC_BOLIVIA_GTK_TYPE_INFO_DIALOG, SinticBoliviaGtkInfoDialogClass))
#define SINTIC_BOLIVIA_GTK_IS_INFO_DIALOG(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SINTIC_BOLIVIA_GTK_TYPE_INFO_DIALOG))
#define SINTIC_BOLIVIA_GTK_IS_INFO_DIALOG_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), SINTIC_BOLIVIA_GTK_TYPE_INFO_DIALOG))
#define SINTIC_BOLIVIA_GTK_INFO_DIALOG_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), SINTIC_BOLIVIA_GTK_TYPE_INFO_DIALOG, SinticBoliviaGtkInfoDialogClass))

typedef struct _SinticBoliviaGtkInfoDialog SinticBoliviaGtkInfoDialog;
typedef struct _SinticBoliviaGtkInfoDialogClass SinticBoliviaGtkInfoDialogClass;
typedef struct _SinticBoliviaGtkInfoDialogPrivate SinticBoliviaGtkInfoDialogPrivate;

#define SINTIC_BOLIVIA_GTK_TYPE_SB_DATE_PICKER (sintic_bolivia_gtk_sb_date_picker_get_type ())
#define SINTIC_BOLIVIA_GTK_SB_DATE_PICKER(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SINTIC_BOLIVIA_GTK_TYPE_SB_DATE_PICKER, SinticBoliviaGtkSBDatePicker))
#define SINTIC_BOLIVIA_GTK_SB_DATE_PICKER_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), SINTIC_BOLIVIA_GTK_TYPE_SB_DATE_PICKER, SinticBoliviaGtkSBDatePickerClass))
#define SINTIC_BOLIVIA_GTK_IS_SB_DATE_PICKER(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SINTIC_BOLIVIA_GTK_TYPE_SB_DATE_PICKER))
#define SINTIC_BOLIVIA_GTK_IS_SB_DATE_PICKER_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), SINTIC_BOLIVIA_GTK_TYPE_SB_DATE_PICKER))
#define SINTIC_BOLIVIA_GTK_SB_DATE_PICKER_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), SINTIC_BOLIVIA_GTK_TYPE_SB_DATE_PICKER, SinticBoliviaGtkSBDatePickerClass))

typedef struct _SinticBoliviaGtkSBDatePicker SinticBoliviaGtkSBDatePicker;
typedef struct _SinticBoliviaGtkSBDatePickerClass SinticBoliviaGtkSBDatePickerClass;
typedef struct _SinticBoliviaGtkSBDatePickerPrivate SinticBoliviaGtkSBDatePickerPrivate;

#define SINTIC_BOLIVIA_GTK_TYPE_SB_CAIRO_CELL_TABLE (sintic_bolivia_gtk_sb_cairo_cell_table_get_type ())
#define SINTIC_BOLIVIA_GTK_SB_CAIRO_CELL_TABLE(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SINTIC_BOLIVIA_GTK_TYPE_SB_CAIRO_CELL_TABLE, SinticBoliviaGtkSBCairoCellTable))
#define SINTIC_BOLIVIA_GTK_SB_CAIRO_CELL_TABLE_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), SINTIC_BOLIVIA_GTK_TYPE_SB_CAIRO_CELL_TABLE, SinticBoliviaGtkSBCairoCellTableClass))
#define SINTIC_BOLIVIA_GTK_IS_SB_CAIRO_CELL_TABLE(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SINTIC_BOLIVIA_GTK_TYPE_SB_CAIRO_CELL_TABLE))
#define SINTIC_BOLIVIA_GTK_IS_SB_CAIRO_CELL_TABLE_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), SINTIC_BOLIVIA_GTK_TYPE_SB_CAIRO_CELL_TABLE))
#define SINTIC_BOLIVIA_GTK_SB_CAIRO_CELL_TABLE_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), SINTIC_BOLIVIA_GTK_TYPE_SB_CAIRO_CELL_TABLE, SinticBoliviaGtkSBCairoCellTableClass))

typedef struct _SinticBoliviaGtkSBCairoCellTable SinticBoliviaGtkSBCairoCellTable;
typedef struct _SinticBoliviaGtkSBCairoCellTableClass SinticBoliviaGtkSBCairoCellTableClass;
typedef struct _SinticBoliviaGtkSBCairoCellTablePrivate SinticBoliviaGtkSBCairoCellTablePrivate;

#define SINTIC_BOLIVIA_GTK_TYPE_SB_CAIRO_TABLE (sintic_bolivia_gtk_sb_cairo_table_get_type ())
#define SINTIC_BOLIVIA_GTK_SB_CAIRO_TABLE(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SINTIC_BOLIVIA_GTK_TYPE_SB_CAIRO_TABLE, SinticBoliviaGtkSBCairoTable))
#define SINTIC_BOLIVIA_GTK_SB_CAIRO_TABLE_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), SINTIC_BOLIVIA_GTK_TYPE_SB_CAIRO_TABLE, SinticBoliviaGtkSBCairoTableClass))
#define SINTIC_BOLIVIA_GTK_IS_SB_CAIRO_TABLE(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SINTIC_BOLIVIA_GTK_TYPE_SB_CAIRO_TABLE))
#define SINTIC_BOLIVIA_GTK_IS_SB_CAIRO_TABLE_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), SINTIC_BOLIVIA_GTK_TYPE_SB_CAIRO_TABLE))
#define SINTIC_BOLIVIA_GTK_SB_CAIRO_TABLE_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), SINTIC_BOLIVIA_GTK_TYPE_SB_CAIRO_TABLE, SinticBoliviaGtkSBCairoTableClass))

typedef struct _SinticBoliviaGtkSBCairoTable SinticBoliviaGtkSBCairoTable;
typedef struct _SinticBoliviaGtkSBCairoTableClass SinticBoliviaGtkSBCairoTableClass;
typedef struct _SinticBoliviaGtkSBCairoTablePrivate SinticBoliviaGtkSBCairoTablePrivate;

#define SINTIC_BOLIVIA_GTK_TYPE_SB_CAIRO_OBJECT (sintic_bolivia_gtk_sb_cairo_object_get_type ())
#define SINTIC_BOLIVIA_GTK_SB_CAIRO_OBJECT(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SINTIC_BOLIVIA_GTK_TYPE_SB_CAIRO_OBJECT, SinticBoliviaGtkSBCairoObject))
#define SINTIC_BOLIVIA_GTK_SB_CAIRO_OBJECT_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), SINTIC_BOLIVIA_GTK_TYPE_SB_CAIRO_OBJECT, SinticBoliviaGtkSBCairoObjectClass))
#define SINTIC_BOLIVIA_GTK_IS_SB_CAIRO_OBJECT(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SINTIC_BOLIVIA_GTK_TYPE_SB_CAIRO_OBJECT))
#define SINTIC_BOLIVIA_GTK_IS_SB_CAIRO_OBJECT_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), SINTIC_BOLIVIA_GTK_TYPE_SB_CAIRO_OBJECT))
#define SINTIC_BOLIVIA_GTK_SB_CAIRO_OBJECT_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), SINTIC_BOLIVIA_GTK_TYPE_SB_CAIRO_OBJECT, SinticBoliviaGtkSBCairoObjectClass))

typedef struct _SinticBoliviaGtkSBCairoObject SinticBoliviaGtkSBCairoObject;
typedef struct _SinticBoliviaGtkSBCairoObjectClass SinticBoliviaGtkSBCairoObjectClass;
typedef struct _SinticBoliviaGtkSBCairoObjectPrivate SinticBoliviaGtkSBCairoObjectPrivate;

#define SINTIC_BOLIVIA_GTK_TYPE_SB_CAIRO_PARAGRAPH (sintic_bolivia_gtk_sb_cairo_paragraph_get_type ())
#define SINTIC_BOLIVIA_GTK_SB_CAIRO_PARAGRAPH(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SINTIC_BOLIVIA_GTK_TYPE_SB_CAIRO_PARAGRAPH, SinticBoliviaGtkSBCairoParagraph))
#define SINTIC_BOLIVIA_GTK_SB_CAIRO_PARAGRAPH_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), SINTIC_BOLIVIA_GTK_TYPE_SB_CAIRO_PARAGRAPH, SinticBoliviaGtkSBCairoParagraphClass))
#define SINTIC_BOLIVIA_GTK_IS_SB_CAIRO_PARAGRAPH(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SINTIC_BOLIVIA_GTK_TYPE_SB_CAIRO_PARAGRAPH))
#define SINTIC_BOLIVIA_GTK_IS_SB_CAIRO_PARAGRAPH_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), SINTIC_BOLIVIA_GTK_TYPE_SB_CAIRO_PARAGRAPH))
#define SINTIC_BOLIVIA_GTK_SB_CAIRO_PARAGRAPH_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), SINTIC_BOLIVIA_GTK_TYPE_SB_CAIRO_PARAGRAPH, SinticBoliviaGtkSBCairoParagraphClass))

typedef struct _SinticBoliviaGtkSBCairoParagraph SinticBoliviaGtkSBCairoParagraph;
typedef struct _SinticBoliviaGtkSBCairoParagraphClass SinticBoliviaGtkSBCairoParagraphClass;
typedef struct _SinticBoliviaGtkSBCairoParagraphPrivate SinticBoliviaGtkSBCairoParagraphPrivate;

#define SINTIC_BOLIVIA_GTK_TYPE_TAG (sintic_bolivia_gtk_tag_get_type ())
#define SINTIC_BOLIVIA_GTK_TAG(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SINTIC_BOLIVIA_GTK_TYPE_TAG, SinticBoliviaGtkTag))
#define SINTIC_BOLIVIA_GTK_TAG_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), SINTIC_BOLIVIA_GTK_TYPE_TAG, SinticBoliviaGtkTagClass))
#define SINTIC_BOLIVIA_GTK_IS_TAG(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SINTIC_BOLIVIA_GTK_TYPE_TAG))
#define SINTIC_BOLIVIA_GTK_IS_TAG_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), SINTIC_BOLIVIA_GTK_TYPE_TAG))
#define SINTIC_BOLIVIA_GTK_TAG_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), SINTIC_BOLIVIA_GTK_TYPE_TAG, SinticBoliviaGtkTagClass))

typedef struct _SinticBoliviaGtkTag SinticBoliviaGtkTag;
typedef struct _SinticBoliviaGtkTagClass SinticBoliviaGtkTagClass;
typedef struct _SinticBoliviaGtkTagPrivate SinticBoliviaGtkTagPrivate;

#define SINTIC_BOLIVIA_GTK_TYPE_DB_TABLE_TREE_VIEW (sintic_bolivia_gtk_db_table_tree_view_get_type ())
#define SINTIC_BOLIVIA_GTK_DB_TABLE_TREE_VIEW(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SINTIC_BOLIVIA_GTK_TYPE_DB_TABLE_TREE_VIEW, SinticBoliviaGtkDbTableTreeView))
#define SINTIC_BOLIVIA_GTK_DB_TABLE_TREE_VIEW_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), SINTIC_BOLIVIA_GTK_TYPE_DB_TABLE_TREE_VIEW, SinticBoliviaGtkDbTableTreeViewClass))
#define SINTIC_BOLIVIA_GTK_IS_DB_TABLE_TREE_VIEW(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SINTIC_BOLIVIA_GTK_TYPE_DB_TABLE_TREE_VIEW))
#define SINTIC_BOLIVIA_GTK_IS_DB_TABLE_TREE_VIEW_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), SINTIC_BOLIVIA_GTK_TYPE_DB_TABLE_TREE_VIEW))
#define SINTIC_BOLIVIA_GTK_DB_TABLE_TREE_VIEW_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), SINTIC_BOLIVIA_GTK_TYPE_DB_TABLE_TREE_VIEW, SinticBoliviaGtkDbTableTreeViewClass))

typedef struct _SinticBoliviaGtkDbTableTreeView SinticBoliviaGtkDbTableTreeView;
typedef struct _SinticBoliviaGtkDbTableTreeViewClass SinticBoliviaGtkDbTableTreeViewClass;
typedef struct _SinticBoliviaGtkDbTableTreeViewPrivate SinticBoliviaGtkDbTableTreeViewPrivate;

#define SINTIC_BOLIVIA_GTK_TYPE_GTK_HELPER (sintic_bolivia_gtk_gtk_helper_get_type ())
#define SINTIC_BOLIVIA_GTK_GTK_HELPER(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SINTIC_BOLIVIA_GTK_TYPE_GTK_HELPER, SinticBoliviaGtkGtkHelper))
#define SINTIC_BOLIVIA_GTK_GTK_HELPER_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), SINTIC_BOLIVIA_GTK_TYPE_GTK_HELPER, SinticBoliviaGtkGtkHelperClass))
#define SINTIC_BOLIVIA_GTK_IS_GTK_HELPER(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SINTIC_BOLIVIA_GTK_TYPE_GTK_HELPER))
#define SINTIC_BOLIVIA_GTK_IS_GTK_HELPER_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), SINTIC_BOLIVIA_GTK_TYPE_GTK_HELPER))
#define SINTIC_BOLIVIA_GTK_GTK_HELPER_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), SINTIC_BOLIVIA_GTK_TYPE_GTK_HELPER, SinticBoliviaGtkGtkHelperClass))

typedef struct _SinticBoliviaGtkGtkHelper SinticBoliviaGtkGtkHelper;
typedef struct _SinticBoliviaGtkGtkHelperClass SinticBoliviaGtkGtkHelperClass;
typedef struct _SinticBoliviaGtkGtkHelperPrivate SinticBoliviaGtkGtkHelperPrivate;

#define SINTIC_BOLIVIA_GTK_TYPE_SB_PRINT_PREVIEW (sintic_bolivia_gtk_sb_print_preview_get_type ())
#define SINTIC_BOLIVIA_GTK_SB_PRINT_PREVIEW(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), SINTIC_BOLIVIA_GTK_TYPE_SB_PRINT_PREVIEW, SinticBoliviaGtkSBPrintPreview))
#define SINTIC_BOLIVIA_GTK_SB_PRINT_PREVIEW_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), SINTIC_BOLIVIA_GTK_TYPE_SB_PRINT_PREVIEW, SinticBoliviaGtkSBPrintPreviewClass))
#define SINTIC_BOLIVIA_GTK_IS_SB_PRINT_PREVIEW(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), SINTIC_BOLIVIA_GTK_TYPE_SB_PRINT_PREVIEW))
#define SINTIC_BOLIVIA_GTK_IS_SB_PRINT_PREVIEW_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), SINTIC_BOLIVIA_GTK_TYPE_SB_PRINT_PREVIEW))
#define SINTIC_BOLIVIA_GTK_SB_PRINT_PREVIEW_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), SINTIC_BOLIVIA_GTK_TYPE_SB_PRINT_PREVIEW, SinticBoliviaGtkSBPrintPreviewClass))

typedef struct _SinticBoliviaGtkSBPrintPreview SinticBoliviaGtkSBPrintPreview;
typedef struct _SinticBoliviaGtkSBPrintPreviewClass SinticBoliviaGtkSBPrintPreviewClass;
typedef struct _SinticBoliviaGtkSBPrintPreviewPrivate SinticBoliviaGtkSBPrintPreviewPrivate;

struct _SinticBoliviaGtkSBGtkModule {
	SinticBoliviaSBModule parent_instance;
	SinticBoliviaGtkSBGtkModulePrivate * priv;
	gchar* _moduleId;
	gchar* _name;
	gchar* _description;
	gchar* _author;
	gdouble _version;
	gchar* resourceFile;
	gchar* resourceNs;
	GResource* res_data;
};

struct _SinticBoliviaGtkSBGtkModuleClass {
	SinticBoliviaSBModuleClass parent_class;
};

struct _SinticBoliviaGtkSBNotebook {
	GtkNotebook parent_instance;
	SinticBoliviaGtkSBNotebookPrivate * priv;
	gint _totalPages;
	GeeHashMap* _pages;
};

struct _SinticBoliviaGtkSBNotebookClass {
	GtkNotebookClass parent_class;
};

struct _SinticBoliviaGtkSBDashboard {
	GtkFixed parent_instance;
	SinticBoliviaGtkSBDashboardPrivate * priv;
	gint fixedWidth;
	gint fixedHeight;
	gint fixedX;
	gint fixedY;
	gint fixedRow;
	gint fixedCol;
	gint widgetHeight;
	gint widgetWidth;
	gint widgetMargin;
};

struct _SinticBoliviaGtkSBDashboardClass {
	GtkFixedClass parent_class;
};

struct _SinticBoliviaGtkSBFixed {
	GtkFixed parent_instance;
	SinticBoliviaGtkSBFixedPrivate * priv;
	gint FixedWidth;
	gint width;
	gint X;
	gint Y;
	gint Margin;
	gint WidgetWidth;
	gint WidgetHeight;
	gint totalColumns;
	gint currentColumn;
};

struct _SinticBoliviaGtkSBFixedClass {
	GtkFixedClass parent_class;
};

struct _SinticBoliviaGtkInfoDialog {
	GtkDialog parent_instance;
	SinticBoliviaGtkInfoDialogPrivate * priv;
	gchar* dlgType;
	GtkEventBox* boxHeader;
};

struct _SinticBoliviaGtkInfoDialogClass {
	GtkDialogClass parent_class;
};

struct _SinticBoliviaGtkSBDatePicker {
	GtkFixed parent_instance;
	SinticBoliviaGtkSBDatePickerPrivate * priv;
	GtkEntry* entryDate;
	GtkCalendar* calendar;
	GtkDialog* popup;
};

struct _SinticBoliviaGtkSBDatePickerClass {
	GtkFixedClass parent_class;
};

struct _SinticBoliviaGtkSBCairoCellTable {
	GObject parent_instance;
	SinticBoliviaGtkSBCairoCellTablePrivate * priv;
	gchar* Align;
	gdouble Width;
	gdouble Height;
	gboolean Border;
	gchar* Text;
	gdouble _x;
	gdouble _y;
	PangoLayout* _layout;
	cairo_t* _cr;
};

struct _SinticBoliviaGtkSBCairoCellTableClass {
	GObjectClass parent_class;
};

struct _SinticBoliviaGtkSBCairoTable {
	GObject parent_instance;
	SinticBoliviaGtkSBCairoTablePrivate * priv;
	cairo_t* _cr;
	PangoLayout* _layout;
	guint _columns;
	guint _rows;
	gdouble* _columnsWidth;
	gint _columnsWidth_length1;
	guint _nextColumnIndex;
	guint _nextRowIndex;
	gdouble _x;
	gdouble _y;
	gdouble _nextX;
	gdouble _nextY;
	gdouble Height;
};

struct _SinticBoliviaGtkSBCairoTableClass {
	GObjectClass parent_class;
};

struct _SinticBoliviaGtkSBCairoObject {
	GObject parent_instance;
	SinticBoliviaGtkSBCairoObjectPrivate * priv;
	gchar* type;
	gint height;
	gint width;
	cairo_t* context;
	PangoLayout* layout;
	gdouble PageWidth;
};

struct _SinticBoliviaGtkSBCairoObjectClass {
	GObjectClass parent_class;
	void (*SetWidth) (SinticBoliviaGtkSBCairoObject* self, gint w);
	void (*CalculateSize) (SinticBoliviaGtkSBCairoObject* self);
	void (*Draw) (SinticBoliviaGtkSBCairoObject* self);
};

struct _SinticBoliviaGtkSBCairoParagraph {
	SinticBoliviaGtkSBCairoObject parent_instance;
	SinticBoliviaGtkSBCairoParagraphPrivate * priv;
	gchar* text;
	gchar* Font;
	gdouble FontSize;
	gchar* Align;
};

struct _SinticBoliviaGtkSBCairoParagraphClass {
	SinticBoliviaGtkSBCairoObjectClass parent_class;
};

struct _SinticBoliviaGtkTag {
	GtkFixed parent_instance;
	SinticBoliviaGtkTagPrivate * priv;
	GtkLabel* label1;
	GtkButton* button1;
};

struct _SinticBoliviaGtkTagClass {
	GtkFixedClass parent_class;
};

struct _SinticBoliviaGtkDbTableTreeView {
	GtkTreeView parent_instance;
	SinticBoliviaGtkDbTableTreeViewPrivate * priv;
	SinticBoliviaDatabaseSBDatabase* dbh;
	gchar* dbTable;
	gchar** tableColumns;
	gint tableColumns_length1;
	gchar** treeviewColumns;
	gint treeviewColumns_length1;
	gchar* query;
};

struct _SinticBoliviaGtkDbTableTreeViewClass {
	GtkTreeViewClass parent_class;
};

struct _SinticBoliviaGtkGtkHelper {
	GObject parent_instance;
	SinticBoliviaGtkGtkHelperPrivate * priv;
};

struct _SinticBoliviaGtkGtkHelperClass {
	GObjectClass parent_class;
};

struct _SinticBoliviaGtkSBPrintPreview {
	GtkBox parent_instance;
	SinticBoliviaGtkSBPrintPreviewPrivate * priv;
	gdouble _ZOOM_IN_FACTOR;
	gdouble _ZOOM_OUT_FACTOR;
	GtkPrintOperation* _operation;
	GtkPrintContext* _context;
	GtkPrintOperationPreview* _operationPreview;
	GtkPageSetup* _pageSetup;
	GtkLayout* _layout;
	GtkScrolledWindow* _scrolledWindow;
	GtkToolButton* _next;
	GtkToolButton* _prev;
	GtkToolItem* _multi;
	GtkToolItem* _zoomOne;
	GtkToolItem* _zoomFit;
	GtkToolButton* _zoomIn;
	GtkToolButton* _zoomOut;
	GtkToolButton* _buttonPrint;
	GtkEntry* _pageEntry;
	GtkLabel* _labelLastPage;
	gdouble _paperWidth;
	gdouble _paperHeight;
	gdouble _pixelsWidth;
	gdouble _pixelsHeight;
	gdouble _dpi;
	gdouble _scale;
	gint _PAGE_PAD;
	gint _tile_w;
	gint _tile_h;
	gint _rows;
	gint _cols;
	guint _n_pages;
	guint _cur_page;
	gdouble _dpi_x;
	gdouble _dpi_y;
	guint TotalPages;
	guint CurrentPage;
};

struct _SinticBoliviaGtkSBPrintPreviewClass {
	GtkBoxClass parent_class;
};


GType sintic_bolivia_gtk_sb_gtk_module_get_type (void) G_GNUC_CONST;
void sintic_bolivia_gtk_sb_gtk_module_LoadResources (SinticBoliviaGtkSBGtkModule* self);
GtkBuilder* sintic_bolivia_gtk_sb_gtk_module_GetGladeUi (SinticBoliviaGtkSBGtkModule* self, const gchar* ui_file, const gchar* t_domain);
GInputStream* sintic_bolivia_gtk_sb_gtk_module_GetInputStream (SinticBoliviaGtkSBGtkModule* self, const gchar* file);
GdkPixbuf* sintic_bolivia_gtk_sb_gtk_module_GetPixbuf (SinticBoliviaGtkSBGtkModule* self, const gchar* image, gint width, gint height);
gchar** sintic_bolivia_gtk_sb_gtk_module_GetSQLFromResource (SinticBoliviaGtkSBGtkModule* self, const gchar* sql_file, int* result_length1);
SinticBoliviaGtkSBGtkModule* sintic_bolivia_gtk_sb_gtk_module_construct (GType object_type);
GType sintic_bolivia_gtk_sb_notebook_get_type (void) G_GNUC_CONST;
SinticBoliviaGtkSBNotebook* sintic_bolivia_gtk_sb_notebook_new (void);
SinticBoliviaGtkSBNotebook* sintic_bolivia_gtk_sb_notebook_construct (GType object_type);
gint sintic_bolivia_gtk_sb_notebook_AddPage (SinticBoliviaGtkSBNotebook* self, const gchar* page_id, const gchar* title, GtkWidget* content);
gboolean sintic_bolivia_gtk_sb_notebook_RemovePage (SinticBoliviaGtkSBNotebook* self, const gchar* page_id);
GtkWidget* sintic_bolivia_gtk_sb_notebook_GetPage (SinticBoliviaGtkSBNotebook* self, const gchar* page_id);
void sintic_bolivia_gtk_sb_notebook_SetCurrentPageById (SinticBoliviaGtkSBNotebook* self, const gchar* page_id);
GType sintic_bolivia_gtk_sb_dashboard_get_type (void) G_GNUC_CONST;
SinticBoliviaGtkSBDashboard* sintic_bolivia_gtk_sb_dashboard_new (void);
SinticBoliviaGtkSBDashboard* sintic_bolivia_gtk_sb_dashboard_construct (GType object_type);
void sintic_bolivia_gtk_sb_dashboard_Add (SinticBoliviaGtkSBDashboard* self, GtkWidget* child);
gint sintic_bolivia_gtk_sb_dashboard_get_Width (SinticBoliviaGtkSBDashboard* self);
void sintic_bolivia_gtk_sb_dashboard_set_Width (SinticBoliviaGtkSBDashboard* self, gint value);
GType sintic_bolivia_gtk_sb_fixed_get_type (void) G_GNUC_CONST;
SinticBoliviaGtkSBFixed* sintic_bolivia_gtk_sb_fixed_new (void);
SinticBoliviaGtkSBFixed* sintic_bolivia_gtk_sb_fixed_construct (GType object_type);
void sintic_bolivia_gtk_sb_fixed_Build (SinticBoliviaGtkSBFixed* self);
void sintic_bolivia_gtk_sb_fixed_SetEvents (SinticBoliviaGtkSBFixed* self);
void sintic_bolivia_gtk_sb_fixed_SetWidgetSize (SinticBoliviaGtkSBFixed* self, gint width, gint height);
void sintic_bolivia_gtk_sb_fixed_AddWidget (SinticBoliviaGtkSBFixed* self, GtkWidget* w);
gint sintic_bolivia_gtk_sb_fixed_get_Width (SinticBoliviaGtkSBFixed* self);
void sintic_bolivia_gtk_sb_fixed_set_Width (SinticBoliviaGtkSBFixed* self, gint value);
GType sintic_bolivia_gtk_info_dialog_get_type (void) G_GNUC_CONST;
SinticBoliviaGtkInfoDialog* sintic_bolivia_gtk_info_dialog_new (const gchar* type);
SinticBoliviaGtkInfoDialog* sintic_bolivia_gtk_info_dialog_construct (GType object_type, const gchar* type);
void sintic_bolivia_gtk_info_dialog_Build (SinticBoliviaGtkInfoDialog* self);
void sintic_bolivia_gtk_info_dialog_SetEvents (SinticBoliviaGtkInfoDialog* self);
void sintic_bolivia_gtk_info_dialog_OnButtonCloseClicked (SinticBoliviaGtkInfoDialog* self);
const gchar* sintic_bolivia_gtk_info_dialog_get_Title (SinticBoliviaGtkInfoDialog* self);
void sintic_bolivia_gtk_info_dialog_set_Title (SinticBoliviaGtkInfoDialog* self, const gchar* value);
const gchar* sintic_bolivia_gtk_info_dialog_get_Message (SinticBoliviaGtkInfoDialog* self);
void sintic_bolivia_gtk_info_dialog_set_Message (SinticBoliviaGtkInfoDialog* self, const gchar* value);
GtkLabel* sintic_bolivia_gtk_info_dialog_get_LabelTitle (SinticBoliviaGtkInfoDialog* self);
void sintic_bolivia_gtk_info_dialog_set_LabelTitle (SinticBoliviaGtkInfoDialog* self, GtkLabel* value);
GtkLabel* sintic_bolivia_gtk_info_dialog_get_LabelMessage (SinticBoliviaGtkInfoDialog* self);
void sintic_bolivia_gtk_info_dialog_set_LabelMessage (SinticBoliviaGtkInfoDialog* self, GtkLabel* value);
GtkButton* sintic_bolivia_gtk_info_dialog_get_ButtonClose (SinticBoliviaGtkInfoDialog* self);
void sintic_bolivia_gtk_info_dialog_set_ButtonClose (SinticBoliviaGtkInfoDialog* self, GtkButton* value);
GType sintic_bolivia_gtk_sb_date_picker_get_type (void) G_GNUC_CONST;
SinticBoliviaGtkSBDatePicker* sintic_bolivia_gtk_sb_date_picker_new (void);
SinticBoliviaGtkSBDatePicker* sintic_bolivia_gtk_sb_date_picker_construct (GType object_type);
void sintic_bolivia_gtk_sb_date_picker_SetEvents (SinticBoliviaGtkSBDatePicker* self);
void sintic_bolivia_gtk_sb_date_picker_OnButtonSelectDateClicked (SinticBoliviaGtkSBDatePicker* self);
void sintic_bolivia_gtk_sb_date_picker_OnDateSelected (SinticBoliviaGtkSBDatePicker* self);
void sintic_bolivia_gtk_sb_date_picker_OnDaySelectedDoubleClick (SinticBoliviaGtkSBDatePicker* self);
const gchar* sintic_bolivia_gtk_sb_date_picker_get_DateString (SinticBoliviaGtkSBDatePicker* self);
void sintic_bolivia_gtk_sb_date_picker_set_DateString (SinticBoliviaGtkSBDatePicker* self, const gchar* value);
void sintic_bolivia_gtk_sb_date_picker_set_Icon (SinticBoliviaGtkSBDatePicker* self, GdkPixbuf* value);
GType sintic_bolivia_gtk_sb_cairo_cell_table_get_type (void) G_GNUC_CONST;
SinticBoliviaGtkSBCairoCellTable* sintic_bolivia_gtk_sb_cairo_cell_table_new (cairo_t* cr, PangoLayout* layout);
SinticBoliviaGtkSBCairoCellTable* sintic_bolivia_gtk_sb_cairo_cell_table_construct (GType object_type, cairo_t* cr, PangoLayout* layout);
void sintic_bolivia_gtk_sb_cairo_cell_table_Draw (SinticBoliviaGtkSBCairoCellTable* self);
gdouble sintic_bolivia_gtk_sb_cairo_cell_table_get_X (SinticBoliviaGtkSBCairoCellTable* self);
void sintic_bolivia_gtk_sb_cairo_cell_table_set_X (SinticBoliviaGtkSBCairoCellTable* self, gdouble value);
gdouble sintic_bolivia_gtk_sb_cairo_cell_table_get_Y (SinticBoliviaGtkSBCairoCellTable* self);
void sintic_bolivia_gtk_sb_cairo_cell_table_set_Y (SinticBoliviaGtkSBCairoCellTable* self, gdouble value);
GType sintic_bolivia_gtk_sb_cairo_table_get_type (void) G_GNUC_CONST;
SinticBoliviaGtkSBCairoTable* sintic_bolivia_gtk_sb_cairo_table_new (cairo_t* cr, PangoLayout* layout, guint columns, guint rows);
SinticBoliviaGtkSBCairoTable* sintic_bolivia_gtk_sb_cairo_table_construct (GType object_type, cairo_t* cr, PangoLayout* layout, guint columns, guint rows);
void sintic_bolivia_gtk_sb_cairo_table_SetColumnsWidth (SinticBoliviaGtkSBCairoTable* self, gdouble* widths, int widths_length1);
SinticBoliviaGtkSBCairoCellTable* sintic_bolivia_gtk_sb_cairo_table_AddCell (SinticBoliviaGtkSBCairoTable* self, const gchar* text, const gchar* align, gboolean border);
gdouble sintic_bolivia_gtk_sb_cairo_table_get_X (SinticBoliviaGtkSBCairoTable* self);
void sintic_bolivia_gtk_sb_cairo_table_set_X (SinticBoliviaGtkSBCairoTable* self, gdouble value);
gdouble sintic_bolivia_gtk_sb_cairo_table_get_Y (SinticBoliviaGtkSBCairoTable* self);
void sintic_bolivia_gtk_sb_cairo_table_set_Y (SinticBoliviaGtkSBCairoTable* self, gdouble value);
GType sintic_bolivia_gtk_sb_cairo_object_get_type (void) G_GNUC_CONST;
SinticBoliviaGtkSBCairoObject* sintic_bolivia_gtk_sb_cairo_object_construct (GType object_type, const gchar* type);
void sintic_bolivia_gtk_sb_cairo_object_SetWidth (SinticBoliviaGtkSBCairoObject* self, gint w);
void sintic_bolivia_gtk_sb_cairo_object_CalculateSize (SinticBoliviaGtkSBCairoObject* self);
void sintic_bolivia_gtk_sb_cairo_object_Draw (SinticBoliviaGtkSBCairoObject* self);
cairo_t* sintic_bolivia_gtk_sb_cairo_object_get_Context (SinticBoliviaGtkSBCairoObject* self);
void sintic_bolivia_gtk_sb_cairo_object_set_Context (SinticBoliviaGtkSBCairoObject* self, cairo_t* value);
PangoLayout* sintic_bolivia_gtk_sb_cairo_object_get_PangoLayout (SinticBoliviaGtkSBCairoObject* self);
void sintic_bolivia_gtk_sb_cairo_object_set_PangoLayout (SinticBoliviaGtkSBCairoObject* self, PangoLayout* value);
gint sintic_bolivia_gtk_sb_cairo_object_get_Height (SinticBoliviaGtkSBCairoObject* self);
GType sintic_bolivia_gtk_sb_cairo_paragraph_get_type (void) G_GNUC_CONST;
SinticBoliviaGtkSBCairoParagraph* sintic_bolivia_gtk_sb_cairo_paragraph_new (void);
SinticBoliviaGtkSBCairoParagraph* sintic_bolivia_gtk_sb_cairo_paragraph_construct (GType object_type);
SinticBoliviaGtkSBCairoParagraph* sintic_bolivia_gtk_sb_cairo_paragraph_new_with_context (cairo_t* ctx, gdouble page_width);
SinticBoliviaGtkSBCairoParagraph* sintic_bolivia_gtk_sb_cairo_paragraph_construct_with_context (GType object_type, cairo_t* ctx, gdouble page_width);
void sintic_bolivia_gtk_sb_cairo_paragraph_SetText (SinticBoliviaGtkSBCairoParagraph* self, const gchar* str, const gchar* font, const gchar* align);
const gchar* sintic_bolivia_gtk_sb_cairo_paragraph_get_Text (SinticBoliviaGtkSBCairoParagraph* self);
void sintic_bolivia_gtk_sb_cairo_paragraph_set_Text (SinticBoliviaGtkSBCairoParagraph* self, const gchar* value);
GType sintic_bolivia_gtk_tag_get_type (void) G_GNUC_CONST;
SinticBoliviaGtkTag* sintic_bolivia_gtk_tag_new (void);
SinticBoliviaGtkTag* sintic_bolivia_gtk_tag_construct (GType object_type);
void sintic_bolivia_gtk_tag_SetEvents (SinticBoliviaGtkTag* self);
void sintic_bolivia_gtk_tag_OnButtonRemoveClicked (SinticBoliviaGtkTag* self);
const gchar* sintic_bolivia_gtk_tag_get_Text (SinticBoliviaGtkTag* self);
void sintic_bolivia_gtk_tag_set_Text (SinticBoliviaGtkTag* self, const gchar* value);
GType sintic_bolivia_gtk_db_table_tree_view_get_type (void) G_GNUC_CONST;
SinticBoliviaGtkDbTableTreeView* sintic_bolivia_gtk_db_table_tree_view_new (const gchar* db_table, gchar** cols, int cols_length1, SinticBoliviaDatabaseSBDatabase* _dbh);
SinticBoliviaGtkDbTableTreeView* sintic_bolivia_gtk_db_table_tree_view_construct (GType object_type, const gchar* db_table, gchar** cols, int cols_length1, SinticBoliviaDatabaseSBDatabase* _dbh);
void sintic_bolivia_gtk_db_table_tree_view_ParseColumns (SinticBoliviaGtkDbTableTreeView* self, gchar** cols, int cols_length1);
void sintic_bolivia_gtk_db_table_tree_view_BuildQuery (SinticBoliviaGtkDbTableTreeView* self);
void sintic_bolivia_gtk_db_table_tree_view_Build (SinticBoliviaGtkDbTableTreeView* self);
void sintic_bolivia_gtk_db_table_tree_view_Bind (SinticBoliviaGtkDbTableTreeView* self);
GType sintic_bolivia_gtk_gtk_helper_get_type (void) G_GNUC_CONST;
GtkBuilder* sintic_bolivia_gtk_gtk_helper_GetGladeUI (const gchar* glade_file);
GdkPixbuf* sintic_bolivia_gtk_gtk_helper_GetPixbuf (const gchar* file, gint width, gint height);
void sintic_bolivia_gtk_gtk_helper_BuildTreeViewColumns (gchar** cols, int cols_length1, int cols_length2, GtkTreeView** treeview);
GResource* sintic_bolivia_gtk_gtk_helper_LoadResource (const gchar* resource_file);
GInputStream* sintic_bolivia_gtk_gtk_helper_GetInputStreamFromResource (GResource* res, const gchar* file);
GtkBuilder* sintic_bolivia_gtk_gtk_helper_GetGladeUIFromResource (GResource* res, const gchar* glade_ui);
SinticBoliviaGtkGtkHelper* sintic_bolivia_gtk_gtk_helper_new (void);
SinticBoliviaGtkGtkHelper* sintic_bolivia_gtk_gtk_helper_construct (GType object_type);
GType sintic_bolivia_gtk_sb_print_preview_get_type (void) G_GNUC_CONST;
SinticBoliviaGtkSBPrintPreview* sintic_bolivia_gtk_sb_print_preview_new (GtkPrintOperation* _op, GtkPrintOperationPreview* _op_preview, GtkPrintContext* _context);
SinticBoliviaGtkSBPrintPreview* sintic_bolivia_gtk_sb_print_preview_construct (GType object_type, GtkPrintOperation* _op, GtkPrintOperationPreview* _op_preview, GtkPrintContext* _context);
void sintic_bolivia_gtk_sb_print_preview_buildWidget (SinticBoliviaGtkSBPrintPreview* self);
cairo_status_t sintic_bolivia_gtk_sb_print_preview_writeFunc (SinticBoliviaGtkSBPrintPreview* self, guchar* data, int data_length1);
void sintic_bolivia_gtk_sb_print_preview_setEvents (SinticBoliviaGtkSBPrintPreview* self);
void sintic_bolivia_gtk_sb_print_preview_onPreviewReady (SinticBoliviaGtkSBPrintPreview* self, GtkPrintContext* context);
gboolean sintic_bolivia_gtk_sb_print_preview_OnLayoutDraw (SinticBoliviaGtkSBPrintPreview* self, cairo_t* context);
void sintic_bolivia_gtk_sb_print_preview_buildPageFrame (SinticBoliviaGtkSBPrintPreview* self, cairo_t** context, gdouble width, gdouble height);
void sintic_bolivia_gtk_sb_print_preview_drawPageContent (SinticBoliviaGtkSBPrintPreview* self, cairo_t* context, gint page_number);
void sintic_bolivia_gtk_sb_print_preview_onGotPageSize (SinticBoliviaGtkSBPrintPreview* self, GtkPrintContext* context, GtkPageSetup* page_setup);
void sintic_bolivia_gtk_sb_print_preview_updatePaperSize (SinticBoliviaGtkSBPrintPreview* self);
gdouble sintic_bolivia_gtk_sb_print_preview_getScreenDpi (SinticBoliviaGtkSBPrintPreview* self);
void sintic_bolivia_gtk_sb_print_preview_setZoomFactor (SinticBoliviaGtkSBPrintPreview* self, gdouble zoom);
void sintic_bolivia_gtk_sb_print_preview_updateTileSize (SinticBoliviaGtkSBPrintPreview* self);
void sintic_bolivia_gtk_sb_print_preview_updateLayoutSize (SinticBoliviaGtkSBPrintPreview* self);
gdouble sintic_bolivia_gtk_sb_print_preview_getPaperWidth (SinticBoliviaGtkSBPrintPreview* self);
gdouble sintic_bolivia_gtk_sb_print_preview_getPaperHeight (SinticBoliviaGtkSBPrintPreview* self);
void sintic_bolivia_gtk_sb_print_preview_goToPage (SinticBoliviaGtkSBPrintPreview* self, gint page);
void sintic_bolivia_gtk_sb_print_preview_OnZoomInButtonClicked (SinticBoliviaGtkSBPrintPreview* self);
void sintic_bolivia_gtk_sb_print_preview_OnZoomOutButtonClicked (SinticBoliviaGtkSBPrintPreview* self);
void sintic_bolivia_gtk_sb_print_preview_OnPrevButtonClicked (SinticBoliviaGtkSBPrintPreview* self);
void sintic_bolivia_gtk_sb_print_preview_OnNextButtonClicked (SinticBoliviaGtkSBPrintPreview* self);
cairo_t* sintic_bolivia_gtk_sb_print_preview_get_CairoContext (SinticBoliviaGtkSBPrintPreview* self);


G_END_DECLS

#endif
