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
		
		string method = "show.getInfo";
		string url = "%s/%s?show_name=%s"
			.printf(base_url, method, opts.show_name);
		string data = query_remote (url);
		Json.Object root = json_root_object (data);
		Show show = assemble_show (root);

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

	public List shows_search (string q) {
		string page = "";
		List<Show> shows = new List<Show> ();
		string url = "%s/shows.search?query=%s%s";
		string data = query_remote (url.printf(base_url, q, page));
		Json.Object root = json_root_object (data);
		int p = (int) root.get_int_member ("total_pages");
		
		int i;
		for (i = 0; i < p; i++) {
			page = "&page=%i".printf(i);
			data = query_remote(url.printf(base_url,q,page));
			root = json_root_object (data);
			
			foreach (var show_arr in root.get_array_member ("shows").get_elements () ) {
				var show_obj = show_arr.get_object ();
				shows.append (assemble_show (show_obj));
			}
		
		}
		
		return shows;
	}
	
	/**
	 * PRIVATE Methods
	 */
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
		le.age = new Age (episode.get_int_member ("age"));
		le.hd = episode.get_null_member("hd") ? "" : episode.get_string_member ("hd");
		le.hd720 = episode.get_null_member("720") ? "" : episode.get_string_member ("720");
		le.hd1080 = episode.get_null_member("1080") ? "" : episode.get_string_member ("1080");

		return le;
	}

	private Show assemble_show (Json.Object s) {

		Show show = new Show();
		show.name = s.get_string_member("name");
		show.pretty_name = s.get_string_member("pretty_name");
		show.genre = s.get_string_member("genre");
		show.link = s.get_string_member("link");
		Json.Object episode = s.get_object_member("latest_episode");
		show.latest_episode = assemble_episode (episode);
		
		return show;
	}

}
