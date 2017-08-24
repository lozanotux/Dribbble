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

public class StatusBar : ActionBar {

    public StatusBar () {

        this.get_style_context ().add_class ("statusbar");
        
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


        this.pack_start (add_button);
        this.pack_start (rem_button);

    }

}
