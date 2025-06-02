# What We Have Learned


This chapter provides a comprehensive toolkit for visualizing multivariate relationships, transforming the humble scatterplot into a powerful engine for data exploration and discovery.

• **Enhance, don't just plot**: The basic scatterplot becomes exponentially more informative when we add **smoothers** (regression lines, loess curves), **stratifiers** (grouping by color, shape, or panels), and **data ellipses** that capture correlation, variance, and regression relationships in a single elegant geometric form. These annotations turn static dots into dynamic stories about relationships in your data.

• **Data ellipses are statistical Swiss Army knives**: These beautiful geometric summaries encode an remarkable amount of information—means, standard deviations, correlation, regression slopes, and confidence regions—all in one visual package. When your data are roughly bivariate normal, the ellipse becomes a sufficient summary, telling you everything you need to know about the relationship between two variables.

• **Simpson's Paradox lurks everywhere**: The relationship you see when ignoring grouping variables can completely reverse when you properly account for those groups. Marginal correlations can be negative while all within-group correlations are positive (or vice versa). This fundamental lesson reminds us that **context matters**—always consider what variables you might be overlooking.

• **Scatterplot matrices scale gracefully**: When you have multiple variables, pairs plots let you see all pairwise relationships simultaneously. Add **visual thinning** (removing points, keeping only smoothers and ellipses) and **effect ordering** (arranging variables by similarity) to handle even larger numbers of variables while maintaining interpretability.

• **Generalized pairs plots bridge data types**: Modern extensions handle mixtures of continuous and categorical variables elegantly, using appropriate plot types for each combination—scatterplots for continuous pairs, boxplots for continuous-categorical combinations, and mosaic plots for categorical pairs. This unified framework means no variable gets left behind.

• **Parallel coordinates reveal high-dimensional patterns**: When scatterplot matrices reach their limits, parallel coordinate plots let you visualize dozens of variables simultaneously. Each observation becomes a connected line across parallel axes, revealing clusters, outliers, and multivariate patterns that would be invisible in traditional 2D projections.

• **Tours provide dynamic exploration**: Animated statistical tours take you on guided journeys through high-dimensional data space, smoothly rotating through different 2D projections. Whether taking a random grand tour or a guided tour optimized for specific features (clusters, outliers, group separation), these methods reveal structures hidden in static displays.

• **Network diagrams conquer "big p" data**: When correlations become too numerous to display traditionally, network graphs show variables as nodes connected by edges representing associations. Partial correlation networks reveal **direct** relationships between variables with all other influences removed—the difference between marginal and conditional independence becomes visually apparent.

• **Visual thinning is a superpower**: As datasets grow in size and complexity, strategic removal of visual elements (points, axes, labels) while retaining essential summaries (trends, ellipses, networks) lets you maintain clarity and insight. Less can indeed be more when every remaining element carries max