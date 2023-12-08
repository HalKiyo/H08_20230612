import numpy as np

MAP='CAMA'

pop_list = []
name_list = []
inf_path = '../../map/dat/cty_list/cityrange_list03.txt'
for l in open(inf_path).readlines():
    data = l[:-1].split('	')
    pop_list.append(int(data[4]))
    name_list.append(data[5])

pop = np.fromfile('../../map/dat/pop_tot_/C05_a___20000000.gl5', 'float32').reshape(2160, 4320)
area = np.fromfile(f'../../map/dat/lnd_ara_/lndara.{MAP}.gl5', 'float32').reshape(2160, 4320)
pop_d = (pop/area/1000./1000.)

for num in range(1,501,1):   ##cheak city number##
#for num in range(1,101,1):   ##cheak city number##
#for num in range(101,201,1):   ##cheak city number##
#for num in range(201,301,1):   ##cheak city number##
#for num in range(301,401,1):   ##cheak city number##
#for num in range(401,501,1):   ##cheak city number##
#for num in range(501,601,1):   ##cheak city number##
#for num in range(601,751,1):   ##cheak city number##
#for num in range(751,801,1):   ##cheak city number##
#for num in range(801,851,1):   ##cheak city number##
#for num in range(851,901,1):   ##cheak city number##

    tt = 1000
    tt_1 = 1000
    tt_2 = 2000
    tt_3 = 3000
    location = np.fromfile(f'../../map/cty_cnt_/city_%08d.gl5'%(num),'float32').reshape(2160,4320)
    pop_city = pop_list[num-1]*1000
    city_name = name_list[num-1]
    x = np.where(location==1)[0]
    y = np.where(location==1)[1] 
    tt_list = [1000,2000,3000]

    #-------------------ROUND 1----------------------
    A = area[x,y]/1000./1000.
    thre_1 = tt_1*A
    thre_2 = tt_2*A
    thre_3 = tt_3*A

    pop_mask = 0 

    mask_1 = np.zeros((2160,4320),'float32')
    mask_1[x,y] = 1
    mask_2 = np.zeros((2160,4320),'float32')
    mask_2[x,y] = 1
    mask_3 = np.zeros((2160,4320),'float32')
    mask_3[x,y] = 1

    search_1 = np.zeros((2160,4320),'float32')
    search_1[x,y] = 1
    search_2 = np.zeros((2160,4320),'float32')
    search_2[x,y] = 1
    for a in range(x-1,x+2):
        for b in range(y-1,y+2):
            search_2[a,b] = 1
    judgement = np.sum(search_2-search_1)
    ran = 1

    f_mask_1 = np.zeros((2160,4320),'float32')
    f_mask_2 = np.zeros((2160,4320),'float32')
    f_mask_3 = np.zeros((2160,4320),'float32')

    roop = 1
    while judgement>0 and roop<8:
        for a in range(0,2160,1):
            for b in range(0,4320,1):
                if search_2[a,b]==1:
                    if pop[a,b]>thre_1:
                        if mask_1[a-1,b-1]==1 or mask_1[a,b-1]==1 or mask_1[a+1,b-1]==1 or mask_1[a-1,b]==1 or mask_1[a+1,b]==1 or mask_1[a-1,b]==1 or mask_1[a+1,b]==1 or mask_1[a-1,b+1]==1 or mask_1[a,b+1]==1 or mask_1[a+1,b+1]==1:
                            mask_1[a,b] = 1
                        elif pop[a,b]>thre_2:
                        if mask_2[a-1,b-1]==1 or mask_2[a,b-1]==1 or mask_2[a+1,b-1]==1 or mask_2[a-1,b]==1 or mask_2[a+1,b]==1 or mask_2[a-1,b]==1 or mask_2[a+1,b]==1 or mask_2[a-1,b+1]==1 or mask_2[a,b+1]==1 or mask_2[a+1,b+1]==1:
                            mask_2[a,b] = 1
                        elif pop[a,b]>thre_3:
                        if mask_3[a-1,b-1]==1 or mask_3[a,b-1]==1 or mask_3[a+1,b-1]==1 or mask_3[a-1,b]==1 or mask_3[a+1,b]==1 or mask_3[a-1,b]==1 or mask_3[a+1,b]==1 or mask_3[a-1,b+1]==1 or mask_3[a,b+1]==1 or mask_3[a+1,b+1]==1:
                            mask_3[a,b] = 1

    ran = ran + 1
    search_1 = np.copy(search_2)
    for c in range(x-ran,x+ran+1,1):
        for d in range(y-ran,y+ran+1,1):
            search_2[c,d] = 1
    search_2 = search_2-search_1

    judgement_1 = np.sum(mask_1-f_mask_1)
    f_mask_1 = np.copy(mask_1)
    judgement_2 = np.sum(mask_2-f_mask_2)
    f_mask_2 = np.copy(mask_2)
    judgement_3 = np.sum(mask_3-f_mask_3)
    f_mask_3 = np.copy(mask_3)

    JG = [judgement_1,judgement_2,judgement_3]
    judgement = max(JG)

    roop += 1

 mp_1 = mask_1*pop
 pop_mask_1 = np.sum(mp_1)
 mp_2 = mask_2*pop
 pop_mask_2 = np.sum(mp_2)
 mp_3 = mask_3*pop
 pop_mask_3 = np.sum(mp_3)

 pop_mask_list = [pop_mask_1,pop_mask_2,pop_mask_3]
 coverage = [float(M/pop_city) for M in pop_mask_list]
 evl = [abs(C-1.0) for C in coverage]
 min_evl = min(evl)
 best_index = evl.index(min_evl)
 best_coverage = coverage[best_index]

# print "ROUND 1"
# print evl
# print coverage
# print tt_list

#-------------------ROUND 2----------------------
 if best_index==0:
  tt_4 = 500
  tt_best = 1000
  tt_5 = 1500
  pop_mask_best = pop_mask_list[0]
  best_mask = mask_1
 elif best_index==1:
  tt_4 = 1500
  tt_best = 2000
  tt_5 = 2500
  pop_mask_best = pop_mask_list[1]
  best_mask = mask_2
 elif best_index==2:
  tt_4 = 2500
  tt_best = 3000
  tt_5 = 3500
  pop_mask_best = pop_mask_list[2]
  best_mask = mask_3

 tt_list = [tt_4,tt_best,tt_5]
 thre_4 = tt_4*A
 thre_5 = tt_5*A
 thre_list = [tt_4*A,tt_best*A,tt_5*A]

 mask_4 = np.zeros((2160,4320),'float32')
 mask_4[x,y] = 1
 mask_5 = np.zeros((2160,4320),'float32')
 mask_5[x,y] = 1

 search_1 = np.zeros((2160,4320),'float32')
 search_1[x,y] = 1
 search_2 = np.zeros((2160,4320),'float32')
 search_2[x,y] = 1
 for a in range(x-1,x+2):
 	for b in range(y-1,y+2):
 		search_2[a,b] = 1
 judgement = np.sum(search_2-search_1)
 ran = 1

 f_mask_4 = np.zeros((2160,4320),'float32')
 f_mask_5 = np.zeros((2160,4320),'float32')

 roop = 1
 while judgement>0 and roop<8:
 	for a in range(0,2160,1):
 		for b in range(0,4320,1):
 			if search_2[a,b]==1:
 				if pop[a,b]>thre_4:
 					if mask_4[a-1,b-1]==1 or mask_4[a,b-1]==1 or mask_4[a+1,b-1]==1 or mask_4[a-1,b]==1 or mask_4[a+1,b]==1 or mask_4[a-1,b]==1 or mask_4[a+1,b]==1 or mask_4[a-1,b+1]==1 or mask_4[a,b+1]==1 or mask_4[a+1,b+1]==1:
 						mask_4[a,b] = 1
  				elif pop[a,b]>thre_5:
 					if mask_5[a-1,b-1]==1 or mask_5[a,b-1]==1 or mask_5[a+1,b-1]==1 or mask_5[a-1,b]==1 or mask_5[a+1,b]==1 or mask_5[a-1,b]==1 or mask_5[a+1,b]==1 or mask_5[a-1,b+1]==1 or mask_5[a,b+1]==1 or mask_5[a+1,b+1]==1:
 						mask_5[a,b] = 1

 	ran = ran + 1
 	search_1 = np.copy(search_2)
 	for c in range(x-ran,x+ran+1,1):
 		for d in range(y-ran,y+ran+1,1):
 			search_2[c,d] = 1
 	search_2 = search_2-search_1

 	judgement_4 = np.sum(mask_4-f_mask_4)
 	f_mask_4 = np.copy(mask_4)
 	judgement_5 = np.sum(mask_5-f_mask_5)
 	f_mask_5 = np.copy(mask_5)

 	JG = [judgement_4,judgement_5]
 	judgement = max(JG)

	roop += 1

 mp_4 = mask_4*pop
 pop_mask_4 = np.sum(mp_4)
 mp_5 = mask_5*pop
 pop_mask_5 = np.sum(mp_5)

 pop_mask_list_2 = [pop_mask_4,pop_mask_best,pop_mask_5]
 coverage_2 = [float(M/pop_city) for M in pop_mask_list_2]
 evl_2 = [abs(C-1.0) for C in coverage_2]
 min_evl_2 = min(evl_2)
 best_index_2 = evl_2.index(min_evl_2)
 best_coverage_2 = coverage_2[best_index_2]
 pop_best_2 = pop_mask_list_2[best_index_2]
 tt_best_2 = tt_list[best_index_2]
 thre_best_2 = thre_list[best_index_2]

# print "ROUND 2"
# print evl_2
# print coverage_2
# print tt_list

 if best_index_2==0:
  best_mask_2 = mask_4
 elif best_index_2==1:
  best_mask_2 = best_mask
 elif best_index_2==2:
  best_mask_2 = mask_5

#-------------------ROUND 3----------------------
 tt_6 = tt_best_2-250
 tt_7 = tt_best_2+250

 tt_list = [tt_6,tt_best_2,tt_7]
 thre_6 = tt_6*A
 thre_7 = tt_7*A
 thre_list = [thre_6,thre_best_2,thre_7]

 mask_6 = np.zeros((2160,4320),'float32')
 mask_6[x,y] = 1
 mask_7 = np.zeros((2160,4320),'float32')
 mask_7[x,y] = 1

 search_1 = np.zeros((2160,4320),'float32')
 search_1[x,y] = 1
 search_2 = np.zeros((2160,4320),'float32')
 search_2[x,y] = 1
 for a in range(x-1,x+2):
 	for b in range(y-1,y+2):
 		search_2[a,b] = 1
 judgement = np.sum(search_2-search_1)
 ran = 1

 f_mask_6 = np.zeros((2160,4320),'float32')
 f_mask_7 = np.zeros((2160,4320),'float32')

 roop = 1
 while judgement>0 and roop<8:
 	for a in range(0,2160,1):
 		for b in range(0,4320,1):
 			if search_2[a,b]==1:
 				if pop[a,b]>thre_6:
 					if mask_6[a-1,b-1]==1 or mask_6[a,b-1]==1 or mask_6[a+1,b-1]==1 or mask_6[a-1,b]==1 or mask_6[a+1,b]==1 or mask_6[a-1,b]==1 or mask_6[a+1,b]==1 or mask_6[a-1,b+1]==1 or mask_6[a,b+1]==1 or mask_6[a+1,b+1]==1:
 						mask_6[a,b] = 1
  				elif pop[a,b]>thre_7:
 					if mask_7[a-1,b-1]==1 or mask_7[a,b-1]==1 or mask_7[a+1,b-1]==1 or mask_7[a-1,b]==1 or mask_7[a+1,b]==1 or mask_7[a-1,b]==1 or mask_7[a+1,b]==1 or mask_7[a-1,b+1]==1 or mask_7[a,b+1]==1 or mask_7[a+1,b+1]==1:
 						mask_7[a,b] = 1

 	ran = ran + 1
 	search_1 = np.copy(search_2)
 	for c in range(x-ran,x+ran+1,1):
 		for d in range(y-ran,y+ran+1,1):
 			search_2[c,d] = 1
 	search_2 = search_2-search_1

 	judgement_6 = np.sum(mask_6-f_mask_6)
 	f_mask_6 = np.copy(mask_6)
 	judgement_7 = np.sum(mask_7-f_mask_7)
 	f_mask_7 = np.copy(mask_7)

 	JG = [judgement_6,judgement_7]
 	judgement = max(JG)

	roop += 1

 mp_6 = mask_6*pop
 pop_mask_6 = np.sum(mp_6)
 mp_7 = mask_7*pop
 pop_mask_7 = np.sum(mp_7)

 pop_mask_list_3 = [pop_mask_6,pop_best_2,pop_mask_7]
 coverage_3 = [float(M/pop_city) for M in pop_mask_list_3]
 evl_3 = [abs(C-1.0) for C in coverage_3]
 min_evl_3 = min(evl_3)
 best_index_3 = evl_3.index(min_evl_3)
 best_coverage_3 = coverage_3[best_index_3]
 pop_best_3 = pop_mask_list_3[best_index_3]
 tt_best_3 = tt_list[best_index_3]
 thre_best_3 = thre_list[best_index_3]

# print "ROUND 3"
# print evl_3
# print coverage_3
# print tt_list

 if best_index_3==0:
  best_mask_3 = mask_6
 elif best_index_3==1:
  best_mask_3 = best_mask_2
 elif best_index_3==2:
  best_mask_3 = mask_7

 grid_num = np.sum(best_mask_3)
 city_A = best_mask_3*A
 city_area = np.sum(city_A)

#------------------------------------------------
 if tt_best_3 != 3750 and tt_best_3 != 250 and 0.8<=best_coverage_3<=1.2:
  print "citynum %d threshold_1 %d threshold_2 %d pop_mask %d pop_city %d coverage %01f OK grid_num %d city_area %d %s"%(num,tt_best_3,thre_best_3,pop_best_3,pop_city,best_coverage_3,grid_num,city_area,city_name)
 elif tt_best_3 != 3750 and tt_best_3 != 250:
  print "citynum %d threshold_1 %d threshold_2 %d pop_mask %d pop_city %d coverage %01f NG grid_num %d city_area %d %s"%(num,tt_best_3,thre_best_3,pop_best_3,pop_city,best_coverage_3,grid_num,city_area,city_name)
 elif tt_best_3 == 3750:
  print "citynum %d threshold_1 %d threshold_2 %d pop_mask %d pop_city %d coverage %01f high grid_num %d city_area %d %s"%(num,tt_best_3,thre_best_3,pop_best_3,pop_city,best_coverage_3,grid_num,city_area,city_name)
 elif tt_best_3 == 250:
  if 0.8<=best_coverage_3<=1.2:
   print "citynum %d threshold_1 %d threshold_2 %d pop_mask %d pop_city %d coverage %01f low_OK grid_num %d city_area %d %s"%(num,tt_best_3,thre_best_3,pop_best_3,pop_city,best_coverage_3,grid_num,city_area,city_name)
  else:
   print "citynum %d threshold_1 %d threshold_2 %d pop_mask %d pop_city %d coverage %01f low_NG grid_num %d city_area %d %s"%(num,tt_best_3,thre_best_3,pop_best_3,pop_city,best_coverage_3,grid_num,city_area,city_name)

 name = './cty_msk_/txt/city_%08d.txt'%(num)
ff = open(name,'w')
for l in range(0,2160,1):
    line = best_mask_3[l,:]
    aaa = line.tolist()
    aaa = str(aaa)
    aa1 = aaa.strip("[")
    aa2 = aa1.strip("]")
    aa2 = aa2.strip(",")
    ff.write("\n%s"%aa2)
ff.close()

### for convertion ###
#asc2gl5 ../cty_msk_/txt/Johannesburg.txt Johannesburg.gl5
#asc2gl5 ./cty_msk_/txt/Moscow.txt ./urb_msk_/Moscow.gl5
