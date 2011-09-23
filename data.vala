/*
Copyright 2011 Scotty Delicious <scottydelicious@gmail.com>

This file is part of Daily TV Torrents.

Daily TV Torrents is free software: you can redistribute it and/or modify it 
under the terms of the GNU General Public License as published 
by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.

Daily TV Torrents is distributed in the hope that it will be useful, but WITHOUT 
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY 
or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public 
License for more details.

You should have received a copy of the GNU General Public License 
along with Daily TV Torrents. If not, see http://www.gnu.org/licenses/.
*/

using Soup;
using Json;

class DTT.Data : GLib.Object {

	private const string base_url = "http://api.dailytvtorrents.org/1.0/";

	public Data () {
		// Constructor
	}

	public LatestEpisode episode_get_latest (string show_name) {

		string method = "episode.getLatest";
		string url = "%s/%s?show_name=%s".printf(base_url, method, show_name);
		string data = query_remote (url);
		LatestEpisode le = LatestEpisode ();
		Json.Object root = json_root_object (data);
		le = assemble_episode(root);

		return le;

	}

	/*
	 * Methods relating to Shows
	 **/

	public Show show_get_info (Options opts) {
		
		Show show = Show ();
		LatestEpisode le = LatestEpisode ();
		string method = "show.getInfo";
		string url = "%s/%s?show_name=%s"
			.printf(base_url, method, opts.show_name);
		string data = query_remote (url);
		Json.Object root = json_root_object (data);
		Json.Object episode = root.get_object_member("latest_episode");

		show.name = root.get_string_member("name");
		show.pretty_name = root.get_string_member("pretty_name");
		show.genre = root.get_string_member("genre");
		show.link = root.get_string_member("link");
		show.latest_episode = assemble_episode (episode);

		return show;

	}

	public string shows_get_text_info (Options opts) {
		string method = "shows.getTextInfo";
		string other_opts = "";
		other_opts += opts.colors ? "&colors=yes" : "";
		other_opts += opts.links ? "&links=yes" : "";
		string url = "%s/%s?show_names=%s%s"
			.printf(base_url, method, opts.show_name, other_opts);

		return query_remote (url);
	}
	
	// Private Methods
	private string query_remote (string *url) {

		var session = new Soup.SessionAsync();
		Soup.Message message = new Soup.Message("GET", url);
		session.send_message(message);
		
		return (string) message.response_body.flatten().data;

	}

	private Json.Object json_root_object (string json_text) {
		var parser = new Json.Parser();

		try {
			parser.load_from_data (json_text);
		}
		catch (Error e) {
			stderr.printf ("[ERROR]: %s\n", e.message);
		}

		var root_object = parser.get_root().get_object();
		return root_object;
	}

	private LatestEpisode assemble_episode (Json.Object episode) {
		
		LatestEpisode le = LatestEpisode ();

		le.title = episode.get_null_member("title") ? "" : episode.get_string_member ("title");
		le.number = episode.get_null_member("num") ? "" : episode.get_string_member ("num");
		int64 ep_age = episode.get_null_member("age") ? 1 : episode.get_int_member ("age");
		le.age = seconds_to_age (ep_age);
		le.hd = episode.get_null_member("hd") ? "" : episode.get_string_member ("hd");
		le.hd720 = episode.get_null_member("720") ? "" : episode.get_string_member ("720");
		le.hd1080 = episode.get_null_member("1080") ? "" : episode.get_string_member ("1080");

		return le;
	}

	private Age seconds_to_age (int64 seconds) {
		
		Age age = Age ();
		
		age.seconds = (int) seconds % 60;
		age.minutes = (int) seconds /60;
		age.hours = age.minutes / 60;
		age.minutes %= 60;
		age.days = age.hours / 24;
		age.hours %= 24;

		return age;

	}

}
