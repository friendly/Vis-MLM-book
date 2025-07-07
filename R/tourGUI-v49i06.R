# Figure 1
# Get started
library("tourrGui")
gui_tour()

# If plot doesn't automatically show the data, 
# Click "Apply"
# Click "Quit" to close down the GUI window

# Figure 2
gui_xy()
# Click "bottomleft" on the "Axis Locations" column, and click "Apply"
# Watch the tour until projection looks like the one shown
# Click "Pause" to stop it at this position

# Figure 3
# Choose "species" from the "Class selection" menu
# Click "Apply"
# Choose "Guided" from the "Tour Type" column
# Choose "lda_pp" from the index menu
# Click "Apply", and watch until it gets to this projection
# Click "Quit" to close down the GUI window

# Figure 4
gui_density()
# Watch the tour until projection looks like the onw shown
# Click "Pause" to stop it at this position
# Select "hist" from the "Method Type" column
# Watch the tour until projection looks like the one shown
# Click "Pause" to stop it at this position
# Click "Quit" to close down the GUI window

# Figure 5
gui_pcp()
# Click "3" on the "Choose Dimension" column
# Watch the tour until projection looks like the one shown
# Click "Pause" to stop it at this position
# Click "Quit" to close down the GUI window

# Figure 6
gui_scatmat()
# Click "3" on the "Choose Dimension" column
# Watch the tour until projection looks like the one shown
# Click "Pause" to stop it at this position
# Click "Quit" to close down the GUI window

# Figure 7
gui_andrews()
# Click "3" on the "Choose Dimension" column
# Watch the tour until projection looks like the one shown
# Click "Pause" to stop it at this position
# Click "Quit" to close down the GUI window

# Figure 8
gui_stars()
# Click "5" on the "Choose Dimension" column
# Move the "Choose Star Number" slider to 74
# Click "Apply"
# Move the "Speed" scrollbar to 2.5 (speeds it up)
# Watch the tour until projection looks like the one shown
# Click "Pause" to stop it at this position
# Click "Quit" to close down the GUI window

# Figure 9
music <- read.csv("music-sub.csv", row.names = 1)
head(music)
gui_xy(music)
# Click "bottomleft" on the "Axis Locations" column, and click "Apply"
# Watch the tour until projection looks like the one shown
# Click "Pause" to stop it at this position (top right plot)
# Select "Type" on the "Class Selection" menu, and click "Apply"
# Select "Guide" from the "Tour Type" menu and the "lda_pp" index, and click "Apply"
# Watch the tour until projection looks like the one shown
# Click "Pause" to stop it at this position (bottom left plot)
# Select "Artist" on the "Class Selection" menu, and click "Apply"
# Watch the tour until projection looks like the one shown
# Click "Pause" to stop it at this position (bottom right plot)
