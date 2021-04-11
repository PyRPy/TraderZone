

for (sub in sort(companylist$`GICS Sub-Industry`)[1:5]) {
  cat(sub, '----- \n')
  get_data_sub(sub, '2021-01-01', 0.05, 0.01)
  
}
