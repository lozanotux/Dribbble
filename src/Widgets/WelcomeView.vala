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

public class WelcomeView : Box {

    public WelcomeView () {

        var screen = new Welcome ("Playlist is Empty", "Add music to start jamming out");

        screen.valign = Gtk.Align.FILL;
        screen.halign = Gtk.Align.FILL;
        screen.vexpand = true;

        Image open_img = new Image.from_file ("/usr/share/dribbble/folder-open.svg");
        Image drag_img = new Image.from_file ("/usr/share/dribbble/drag-music.png");

        screen.append_with_image (open_img, "Add From Folder", "Pick a folder with your music in it");
        screen.append_with_image (drag_img, "Drag n' Drop", "Toss your music in here");
        screen.set_border_width (32);

        this.add (screen);
        this.show_all ();

    }

}
