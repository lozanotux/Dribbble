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
using Gst;
using Granite.Widgets;

public class InformationView : Box {

    public Gst.PbUtils.Discoverer discover;
    public Entry pat;
    public Button buscar;
    public Label current_time;
    public Label total_time;
    public Gtk.Scale scale;
    public Label song;
    public Label album;

    public InformationView () {

        this.orientation = Gtk.Orientation.VERTICAL;
        this.spacing = 0;

        try {
            discover = new Gst.PbUtils.Discoverer ((Gst.ClockTime) (5 * Gst.SECOND));
        } catch (GLib.Error e) {
            stderr.printf (e.message);
        }
        
        // Instantiate Vars
        pat = new Entry ();
        buscar = new Button.with_label ("Buscar");

        current_time = new Label ("0:00");
        total_time = new Label ("0:00");
        scale = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 0, 1, 0.1);
        scale.draw_value = false;

        song = new Label ("");
        album = new Label ("");

        var entry_box = new Box (Gtk.Orientation.HORIZONTAL, 0);
        var scale_box = new Box (Gtk.Orientation.HORIZONTAL, 0);

        // Packaging Widgets
        entry_box.pack_start (pat, true, true, 4);
        entry_box.pack_start (buscar, false, true, 6);

        scale_box.pack_start (current_time, false, true, 12);
        scale_box.pack_start (scale, true, true, 0);
        scale_box.pack_start (total_time, false, true, 12);

        // Building the Final Widget
        this.pack_start (entry_box, false, true, 6);
        this.pack_start (scale_box, false, true, 2);
        this.pack_start (song, false, true, 2);
        this.pack_start (album, false, true, 2);

        this.show_all ();
    
    }

}
