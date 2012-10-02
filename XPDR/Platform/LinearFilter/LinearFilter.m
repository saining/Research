function [filteredFea] = LinearFilter(filterType, data)
	switch filterType
		case '2D-GaborFilter'
		gopt.f = 1;
        gopt.theta = 0;
        gopt.gamma = 1;
        gopt.eta = 1;
        gopt.size = [15 15];
		[~, filteredFea] = GaborFilter(data, gopt);
		end
	end