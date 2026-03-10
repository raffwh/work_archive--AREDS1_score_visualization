###############
# AREDS Severity score
# - flip flopping score issue
###############

## Making a visualization on how AREDS severity score being graded--USING 2 VISITs CONFIRMATION
## The main issue was that some score was flip flopping between visits.
## This issue came to light due to different AMD progression count between timepoints.
## The cause was in the study design, as the graders could not see the previous score and the previous grader, 
##     so the grade was subjective and caused discordance especially on ambiguous eyes.
##
## This version has extra information like the outcomes of each eye.
## 
## August 2020 


# DATA --------------------------------------------------------------------

      source("SCRIPTS/00_library.R")
      library(tibble)

      aredsscale0 <- 
            read.csv("DATA/printOut_sevScale_sbj.csv")
      

      

# pulling specific examples ----------------------------------------------------------------

      ## choosing few examples from OD
      flipflopsevscalesample1 <- 
            aredsscale0 %>% 
            mutate(vistno0 = 0) %>% 
            # filter(progression_od_sev == 1) %>%  	#_____for when randomly choosing examples
            # sample_n(7) %>% 
            filter(ID2 %in% 
                      c(1160, # nvr progressed
                        1181, # nvr progressed
                        3639, # nvr progressed
                        5019, # unconfirmed
                        4678, # unconfirmed
                        1436, # unconfirmed
                        3734, # unconfirmed
                        1643, # confirmed
                        3865, # confirmed                        
                        1955, # confirmed
                        1793, # confirmed
                        3790, # confirmed
                        3968 # confirmed
                        )) %>% 
            select(1:15,58,30:42,46,48, 44, 52, 50, 56, 54 ) %>% 
            mutate(eye_id = (factor(ID2, # sorting based on imaginary group, not based on ID as intger
                             levels=
                                c(1160, # nvr progressed
                                   1181, # nvr progressed
                                   3639, # nvr progressed
                                   5019, # unconfirmed
                                   4678, # unconfirmed
                                   1436, # unconfirmed
                                   3734, # unconfirmed
                                   1643, # confirmed
                                   3865, # confirmed                                   
                                   1955, # confirmed
                                   1793, # confirmed
                                   3790, # confirmed
                                   3968 # confirmed
                                  )))) %>% 
            arrange(eye_id) %>%  
         # to relabel the axis instead of using the original IDs
            rownames_to_column("forYaxis")  
         
      
      

# Creating data structure as a skeleton for plot --------------------------


      ## transforming the subset data for graph
      ## this is for marking any scale9-12 with box
      flipflopsevscalesample2 <-  
         flipflopsevscalesample1 %>% 
         
         gather(key="severity_n",value="severity_scale", amdsevod0:amdsevod13) %>% 
         gather(key="visit_n",value="visno", vistno0:vistno13) %>% 
         
         arrange(eye_id) %>% 
         filter(substring(severity_n,9) == substring(visit_n,7)) %>% 
         
         mutate(censor_od_sev = if_else(progression_od_sev == 1, censor_od_sev, NA_real_)) %>% 
         mutate(progrss = if_else((censor_od_sev*2)==visno,1,0)) %>% 
         mutate(visit = substring(visit_n,7)) %>% 
         mutate(visit_year = as.numeric( visno / 2)) %>%
         mutate(nvr_confirm = if_else(progression_od_sev == 0 & severity_scale %in% c(9:12), 1, 0 )) %>% 

         # Creating a box on the pre-confirmation visit.....
         # below is if any advanced scale is marked
         #mutate(progrss_check = if_else(severity_scale %in% c(9:12), 1, 0)) 
         
         # OR... if only 1 box before confirmation
         mutate(progrss_check = if_else(lead(progrss) == 1, 1, 0)) %>% 
         
         # confirmation for GA & NV
         mutate(ga_progrss = if_else(progression4_od_sev == 1 &
                                        (censor4_od_sev * 2) == visno , 
                                     1, 0)) %>% 
         mutate(nv_progrss = if_else(progression5_od_sev == 1 &
                                        (censor5_od_sev * 2) == visno , 
                                     1, 0)) %>% 
         mutate(progrss_check_nv = if_else(lead(nv_progrss) == 1, 1, 0)) # since only 1 exple with prog to GA first then NV
         
         
      
      flipflopsevscalesample2$forYaxis <- 
         factor(flipflopsevscalesample2$forYaxis, 
                levels=
                   unique(flipflopsevscalesample2$forYaxis))
      flipflopsevscalesample2$visit <- 
         factor(flipflopsevscalesample2$visit, 
                levels=
                   unique(flipflopsevscalesample2$visit))
      
      
      
      
      ## 
      
      flipflopsevscalesample3 <- 
         flipflopsevscalesample2 %>% 
         
         #### limiting to visit sequence <12 as no eyes in the selection has visit 13 and few has visit 12.
         filter(!visit_n %in% c( "vistno12" , "vistno13" ))  
         
         # 
         # #### for GA confirmation
         # mutate(censor4_od_sev = if_else(progression4_od_sev == 1, censor4_od_sev, NA_real_)) %>% 
         # mutate(progrss_ga = if_else((censor4_od_sev*2)==visno,1,0)) %>% 
         # 
         # #### for NV confirmation
         # mutate(censor5_od_sev = if_else(progression5_od_sev == 1, censor5_od_sev, NA_real_)) %>% 
         # mutate(progrss_nv = if_else((censor5_od_sev*2)==visno,1,0))  
      
      
      
      
      ### Making the additional columns about the progressions status, f.up etc ######

      severity_columns <- 
         flipflopsevscalesample1 %>% 
            mutate(prog_aamd = if_else( progression_od_sev == 1,
                                            "YES" , "NO")) %>% 
            # mutate(prog_ga = if_else( progression4_od_sev == 1,
            #                             "YES" , "NO")) %>%
            # mutate(prog_nv = if_else( progression5_od_sev == 1,
            #                             "YES" , "NO")) %>%
            mutate(year_prog_aamd = if_else( progression_od_sev == 1,
                                           as.character(censor_od_sev), NA_character_)) %>% 
            # mutate(year_prog_ga = if_else( progression4_od_sev == 1,
            #                                as.character(censor4_od_sev), NA_character_)) %>%
            # mutate(year_prog_nv = if_else( progression5_od_sev == 1,
            #                                as.character(censor5_od_sev), NA_character_)) %>%
            # select(1,2 , 39:44) %>%
            select(1,2, 39, 40) %>% 
            gather(-forYaxis, -ID2, key = "variable", value = "value") 
         
      
      

# GRAPHS ------------------------------------------------------------------

            
      theme_geomtext =
         theme_bw()+
         theme(
            panel.background = element_blank(),
            panel.grid = element_blank(),
            panel.border = element_blank(),
            plot.background = element_blank(),
            axis.line.y = element_blank(),
            axis.line.x = element_line(),
            axis.ticks = element_blank(),

            strip.background = element_blank()   
            )

      ## making the right section -- status of progression ----
      
      severityinformation <- 
      ggplot()+
         geom_text(data=severity_columns ,
                   aes( x = variable , 
                        y = as.factor(forYaxis),
                        label = value),
                   family = "FiraCode")+
         
         theme_geomtext+
         theme(axis.line.x = element_line(),
               axis.text.y = element_blank(),
               axis.line.y.left = element_line(size = 1, colour = "#f1f1f1"),
               panel.grid.minor.y = element_line(size = 3))+
         ylab("")+
         xlab("Progression Status")+
         scale_y_discrete(limits =
                             rev(flipflopsevscalesample1$forYaxis[order(as.numeric( flipflopsevscalesample1$forYaxis) )]))+
         scale_x_discrete( position = "top",
                           label = c(
                              "prog_aamd" = "Progressed to advanced AMD",
                              "year_prog_aamd" = "Follow up time")
         )+
         coord_cartesian(ylim = c(1, 13), expand = T)
      
      
      

      ## making the left section -- confirmation detection on each follow up ----
      

      sevscale_plot_year <-
         ggplot()+
         # for the each visit severity scale, shown as if text plot...
         geom_text(data=flipflopsevscalesample2,
                   aes( x = visit_year ,
                        y = as.factor(forYaxis),
                        label = severity_scale),
                   family = "FiraCode")+
         # box for 1 visit pre-confirmation
         geom_point(data=flipflopsevscalesample2 %>% filter(progrss_check == 1),
                    aes( x = visit_year ,
                         y = as.factor(forYaxis)),
                    shape = 22 ,
                    size = 8.7 ,
                    fill = alpha("#f54251", 0.01)) +
         # box for  visit confirmation
         geom_point(data=flipflopsevscalesample2 %>% filter(progrss == 1),
                    aes( x = visit_year ,
                         y = as.factor(forYaxis)),
                    shape = 22 ,
                    size = 8.7 ,
                    fill = alpha("#f54251", 0.58)) +
         geom_point(data=flipflopsevscalesample2 %>% filter(nvr_confirm == 1),
                    aes( x = visit_year ,
                         y = as.factor(forYaxis)),
                    shape = 1 ,
                    size = 9.2 ,
                    fill = alpha("#d1d1d1", 0.58)) +
      
      theme_geomtext+
         ylab("Example eye")+
         xlab("Year of Study Visit")+
         scale_y_discrete(limits =
                             rev(flipflopsevscalesample1$forYaxis[order(as.numeric( flipflopsevscalesample1$forYaxis) )]))+
         scale_x_continuous(breaks = seq(0,12, by=0.5),
                            limits = c(0 , 12),
                            position = "top")+
         coord_cartesian(ylim = c(1, 13), expand = T)
      #







# ARRANGING THE 2 PLOTS  -------------------------------------------------------------------

      combined_sevscale_supFig_year <- 
         ggarrange(sevscale_plot_year,
                   severityinformation,
                   nrow = 1,
                   ncol = 2,
                   align = "hv",
                   widths = c(2.4 , 1))
      
      # combined_sevscale_supFig_visit <- 
      #    ggarrange(sevscale_plot,
      #              severityinformation,
      #              nrow = 1,
      #              ncol = 2,
      #              align = "hv",
      #              widths = c(1.6,1))
      
      

# EXPORT ------------------------------------------------------------------

      
      ggsave("EXPORTS/sevscale_supFig_year_20201113_g.tiff",
             plot = combined_sevscale_supFig_year,
             device = "tiff",
             width = 8,height = 4, units =  'in',
             dpi = 200,
             compression ="lzw")
      

      


      
      
      
      
      
      
      
      
      