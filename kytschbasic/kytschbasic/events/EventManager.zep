/**
 * Compiler
 *
 * @package     KytschBASIC\Core\EventManager
 * @author 		Mike Welsh
 * @copyright   2022 Mike Welsh
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
 * Boston, MA 02110-1301, USA.
 */
namespace KytschBASIC\Events;

use KytschBASIC\Events\Event;

class EventManager
{
    private queue = [];

    public function add(event)
    {
        let this->queue[] = event;
    }

    public function remove(event)
    {
        var key, queue_event;

        for key, queue_event in this->queue {
            if (queue_event->getName() == event->getName()) {
                unset(this->queue[key]);
            }
        }
    }

    public function process(string command)
    {
        var key, event;

        for key, event in this->queue {
            if (!event || !method_exists(event, "trigger")) {
                continue;
            }

            let command = event->trigger(command);

            if (!event->repeat) {
                unset(this->queue[key]);
            }
        }

        return command;
    }
}
