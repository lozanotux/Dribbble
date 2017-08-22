/*
* Copyright (c) 2011-2017 Dribbble
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Juan Pablo Lozano <lozanotux@gmail.com>
*/

using Gtk;
using GLib;
using Granite.Widgets;

public class Dribbble : Gtk.Application {

    public Dribbble () {
        Object (application_id: "com.github.lozanotux.dribbble",
                flags:          ApplicationFlags.FLAGS_NONE);
    }

    protected override void activate () {
        var app_window = new Gtk.ApplicationWindow (this);
        app_window.set_default_size (320, 600);
        app_window.set_resizable (false);

        var player = new Player ();
        player.get_style_context ().add_class("csd");
        app_window.set_titlebar (player);
        app_window.get_style_context ().add_class("main_window");

        var main_box = new Box (Gtk.Orientation.VERTICAL, 0);

        Separator welcome_top_expander = new Separator (Gtk.Orientation.VERTICAL);
        Separator welcome_bot_expander = new Separator (Gtk.Orientation.VERTICAL);

        var open_img = new Image.from_file ("../data/folder-open.svg");
        var drag_img = new Image.from_file ("../data/drag-music.png");

        var welcome_screen = new Welcome("Playlist is Empty", "Add music to start jamming out");
        welcome_screen.valign = Gtk.Align.FILL;
        welcome_screen.halign = Gtk.Align.FILL;
        welcome_screen.vexpand = true;
        welcome_screen.append_with_image (open_img, "Add From Folder", "Pick a folder with your music in it");
        welcome_screen.append_with_image (drag_img, "Drag n' Drop", "Toss your music in here");
        welcome_screen.set_border_width (32);

        ActionBar status_bar = new ActionBar ();
        status_bar.get_style_context ().add_class ("statusbar");
        //ADD BUTTON
        var add_img = new Image ();
        add_img.set_from_icon_name ("list-add-symbolic", Gtk.IconSize.MENU);
        Button add_button = new Button ();
        add_button.set_image (add_img);
        add_button.tooltip_text = "Add Folder";
        //REMOVE BUTTON
        var rem_img = new Image ();
        rem_img.set_from_icon_name ("list-remove-symbolic", Gtk.IconSize.MENU);
        Button rem_button = new Button ();
        rem_button.set_image (rem_img);
        rem_button.tooltip_text = "Remove Folder";
        status_bar.pack_start (add_button);
        status_bar.pack_start (rem_button);

        main_box.pack_start (welcome_top_expander, true, true, 0);
        main_box.pack_start (welcome_screen, true, true, 0);
        main_box.pack_start (welcome_bot_expander, true, true, 0);
        //main_box.pack_end (status_bar, false, true, 0);

        app_window.add (main_box);
        app_window.show_all ();
    }

    public static int main (string[] args) {
        Gtk.init (ref args);//Initializes GTK+

        string css_file = "/home/developer/Projects/Dribbble/src/estilos.css";//CSS file path
	    var css_provider = new Gtk.CssProvider ();//Create a new CSS Provider

	    try
	    {
		    css_provider.load_from_path (css_file);//Load the CSS file from the above path (string)
		    Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default(), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_USER);//Establece un contexto de estilo y la prioridad
	    } catch (Error e) {//Capturing Error
	  	    stderr.printf ("COM.HASHIT.CORE: [ERROR LOADING CSS STYLES [%s]]\n", e.message);
	  	    stderr.printf (">>> Check path: /usr/share/hashit/ui/gtk-widgets.css\n");
	    }

        var app = new Dribbble ();
        return app.run (args);
    }
}
