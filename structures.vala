/*
Copyright 2011 Scotty Delicious <scottydelicious@gmail.com>

This file is part of Daily TV Torrents.

Daily TV Torrents is free software: you can redistribute it and/or modify it 
under the terms of the GNU General License as published 
by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.

Daily TV Torrents is distributed in the hope that it will be useful, but WITHOUT 
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY 
or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General 
License for more details.

You should have received a copy of the GNU General License 
along with Daily TV Torrents. If not, see http://www.gnu.org/licenses/.
*/


struct Options {
	static string show_name;
	int page;
	static string episode_num;
	static string quality;
	bool fallback; 
	int max_age_hours;
	int max_items;
	static string sort; // age (newest first[default]) or score (highest first) 
	bool colors;
	bool links;
}

struct LatestEpisode {
	static string title;
	static string number;
	Age age;
	static string hd;
	static string hd720;
	static string hd1080;
}

struct Age {
	int days;
	int hours;
	int minutes;
	int seconds;

	public static string to_string(Age age) {
		string age_string = "";
		age_string += age.days != 0 ? "%i days, ".printf(age.days) : "";
		age_string += age.hours != 0 ? "%i hours, ".printf(age.hours) : "";
		age_string += age.minutes != 0 ? "%i minutes and ".printf(age.minutes) : "";
		age_string += "%i seconds ago".printf(age.seconds);
		return age_string;
	}

	public static Age seconds_to_age (int64 seconds) {
		
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

struct Show {
	static string name;
	static string pretty_name;
	static string genre;
	static string link;
	LatestEpisode latest_episode;
}
