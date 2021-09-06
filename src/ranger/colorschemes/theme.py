#https://github.com/RougarouTheme/ranger

# This file is part of ranger, the console file manager.
# License: GNU GPL version 3, see the file "AUTHORS" for details.

from __future__ import (absolute_import, division, print_function)

from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import (
    black, blue, cyan, green, magenta, red, white, yellow, default,
    normal, bold, reverse,
    default_colors,
)

class Rougarou(ColorScheme):
    progress_bar_color = 6

    def use(self, context):  # pylint: disable=too-many-branches,too-many-statements
        fg, bg, attr = default_colors

        if context.reset:
            return default_colors

        elif context.in_browser:
            if context.selected:
                attr = reverse
            else:
                attr = normal
            if context.empty or context.error:
                bg = 1
                fg = 0
            if context.border:
                fg = default
            if context.document: #.css, .xml, .pdf, .docx, .ttf, ...
                attr |=normal
                fg = 7
            if context.media:
                if context.image:
                    attr |=normal #.png, .svg, ...
                    fg = 6
                elif context.video: #.mp4
                    fg = 12
                elif context.audio: #.mp3,
                    fg = 12
                else:
                    fg = 6
            if context.container:
                attr |=bold
                fg = 6
            if context.directory:
                attr |= bold
                fg = 6
            elif context.executable and not \
                    any((context.media, context.container,
                         context.fifo, context.socket)): #.sh, .desktop, binary
                attr |= bold
                fg = 10
            if context.socket:
                fg = 6
                attr |= bold
            if context.fifo or context.device:
                fg = 6
                if context.device:
                    attr |= bold
            if context.link:
                fg = 6 if context.good else 6
            if context.tag_marker and not context.selected:
                attr |= bold
                if fg in (red, magenta):
                    fg = 6
                else:
                    fg = 6
            if not context.selected and (context.cut or context.copied):
                fg = black
                attr |= bold
            if context.main_column:
                if context.selected:
                    attr |= bold
                if context.marked:
                    attr |= bold
                    fg = 6
            if context.badinfo:
                if attr & reverse:
                    bg = 6
                else:
                    fg = 6
            if context.inactive_pane:
                fg = 6

        elif context.in_titlebar:
            attr |= bold
            if context.hostname:
                fg = 1 if context.bad else 2
            elif context.directory: #home/$USER/Documents/
                fg = 15
            elif context.tab: #Actived tab background
                if context.good:
                    bg = 15
            elif context.link:
                fg = 12

        elif context.in_statusbar:
            if context.permissions:
                if context.good: #drwxr-xr-x
                    attr |= bold
                    fg = 6
                elif context.bad:
                    attr |= bold
                    bg = 13
                    fg = 13
            if context.marked:
                attr |= bold | reverse
                fg = 6
            if context.frozen:
                attr |= bold | reverse
                fg = 6
            if context.message:
                if context.bad:
                    attr |= bold
                    fg = 6
            if context.loaded:
                bg = self.progress_bar_color
            if context.vcsinfo:
                fg = 6
                attr &= ~bold
            if context.vcscommit:
                fg = 6
                attr &= ~bold
            if context.vcsdate:
                fg = 6
                attr &= ~bold

        if context.text:
            if context.highlight:
                attr |= reverse

        if context.in_taskview:
            if context.title:
                fg = 6

            if context.selected:
                attr |= reverse

            if context.loaded:
                if context.selected:
                    fg = self.progress_bar_color
                else:
                    bg = self.progress_bar_color

        if context.vcsfile and not context.selected:
            attr &= ~bold
            if context.vcsconflict:
                fg = 6
            elif context.vcschanged:
                fg = 6
            elif context.vcsunknown:
                fg = 6
            elif context.vcsstaged:
                fg = 6
            elif context.vcssync:
                fg = 6
            elif context.vcsignored:
                fg = default

        elif context.vcsremote and not context.selected:
            attr &= ~bold
            if context.vcssync or context.vcsnone:
                fg = 6
            elif context.vcsbehind:
                fg = 6
            elif context.vcsahead:
                fg = 6
            elif context.vcsdiverged:
                fg = 6
            elif context.vcsunknown:
                fg = 6

        return fg, bg, attr