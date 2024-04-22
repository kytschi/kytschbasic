/**
 * SCREEN parser
 *
 * @package     KytschBASIC\Libs\Arcade\Parsers\Screen\Screen
 * @author 		Mike Welsh <hello@kytschi.com>
 * @copyright   2022 Mike Welsh
 * @link 		https://kytschbasic.org
 * @version     0.0.1
 *
 * Copyright 2022 Mike Welsh
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
 * Boston, MA  02110-1301, USA.
 */
namespace KytschBASIC\Libs\Arcade\Parsers\Screen;

use KytschBASIC\Parsers\Core\Command;

class Screen extends Command
{
	public function parse(string command, string args)
	{
		if (command == "SCREEN") {
			return this->parseScreen(args);
		} elseif (command == "SCREEN CLOSE") {
			return "</div>";
		}
	}

	public function parseScreen(args)
	{
		var params = "";
		let args = this->args(args);

		if (isset(args[0])) {
			let params .= " id='" . this->setArg(args[0]) . "'";
		} else {
			let params .= " id='" . this->genID("kb-screen") . "'";
		}
		
		return "<div" . params . ">";
	}
}