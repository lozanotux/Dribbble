/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2024 Juan Pablo Lozano <lozanotux@gmail.com>
 */

public class InformationView : Gtk.Box {

    public Gst.PbUtils.Discoverer discover;
    public Gtk.Entry path;
    public Gtk.Button buscar;
    public Gtk.Label current_time;
    public Gtk.Label total_time;
    public Gtk.Scale scale;
    public Gtk.Label title;
    public Gtk.Label artist;

    public InformationView () {
        Object (
            orientation: Gtk.Orientation.VERTICAL,
            spacing: 6
        );
    }

    construct {
        try {
            discover = new Gst.PbUtils.Discoverer ((Gst.ClockTime) (5 * Gst.SECOND));
        } catch (GLib.Error e) {
            warning (e.message);
        }

        // Instantiate Vars
        path = new Gtk.Entry ();
        path.set_hexpand (true);
        buscar = new Gtk.Button.with_label ("Buscar");

        current_time = new Gtk.Label ("0:00");
        total_time = new Gtk.Label ("0:00");
        scale = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 0, 1, 0.1);
        scale.draw_value = false;
        scale.set_hexpand (true);

        var song_info = new Gtk.Box (Gtk.Orientation.VERTICAL, 8);
        title = new Gtk.Label ("");
        title.set_markup ("<b>Unknown</b>");
        title.set_xalign (0.0f);
        artist = new Gtk.Label ("Unknown");
        artist.set_xalign (0.0f);
        song_info.append (title);
        song_info.append (artist);

        var complete_details = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
        var generic_album = new Gtk.Image.from_icon_name ("custom-album-art") {
            pixel_size = 48
        };
        generic_album.set_margin_start (6);
        generic_album.set_margin_end (6);
        complete_details.append (generic_album);
        complete_details.append (song_info);

        var entry_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
        entry_box.set_margin_start (6);
        entry_box.set_margin_end (6);
        entry_box.set_margin_top (6);
        var scale_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
        scale_box.set_margin_start (6);
        scale_box.set_margin_end (6);
        scale_box.set_margin_top (6);

        // Packaging Widgets
        entry_box.append (path);
        entry_box.append (buscar);

        scale_box.append (current_time);
        scale_box.append (scale);
        scale_box.append (total_time);

        // Building the Final Widget
        append (entry_box);
        append (scale_box);
        append (complete_details);
    }

}
