/*
 * This file is part of CHTKC.
 *
 * CHTKC is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * CHTKC is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with CHTKC.  If not, see <https://www.gnu.org/licenses/>.
 *
 * Author: Jianan Wang
 */


#ifndef KC__HEADER_H
#define KC__HEADER_H

#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>


typedef struct {
    uint64_t K;
    uint64_t count_max;
    uint64_t filter_min;
    uint64_t filter_max;
} KC__Header;


bool KC__write_header(const KC__Header* header, FILE* file);
bool KC__read_header(KC__Header* header, FILE* file);

#endif
