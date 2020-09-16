# Futbol

Starter repository for the [Turing School](https://turing.io/) Futbol project.


![futbol](https://media4.giphy.com/media/pdAiipxDMCHni/giphy.gif?cid=5a38a5a28m4l3obg97q27polvov0lk3074a3i1ij7flle8vc&rid=giphy.gif)





Collaboration between: [Connor Ferguson](https://github.com/cpfergus1), [Curtis Bartell](https://github.com/c-bartell), [Greg Mitchell](https://github.com/GregJMitchell), and [Sean Steel](https://github.com/s-steel)

Design Strategy:

For this project everything runs throught the `stat_tracker` file.  All of the statistics methods can be called on `stat_tracker` and in order to return the data, `stat_tracker` looks down into three other classes, the `game_manager`, `team_manager`, or `game_team_manager`.  These three classes then each have their own downstream class, `game`, `team`, and `game_teams`.  Each of the managers can reach down to their respective classes and pull out data for individual instances.  The managers can then use this data for their calculations.  This setup is like a fork, with each branch being a manager and `stat_tracker` connecting them all.  Everything runs up and down the branches of the fork, never crossing between branches.  We then have the `csv_module` that is responsible for generating all the data for each manager.  This strictly generates all the data originating from the csv files and distributes it for each manager.  This module is accessible to only the three managers and consolidates the data generation to one module instead of within each manager.  We also have a `data_call` module.  This module is repsonsible for pulling data in different forms for the manager classes.  It does not do any calculations, those are all done within the manager classes.
