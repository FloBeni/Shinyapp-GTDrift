library(rphylopic)
library(imager)
library(stringr)

list_species = read.delim("www/database/list_species.tab")
taxonomy = read.delim("www/taxonomy.tab")

list_species = list_species[!list_species$species %in% str_replace_all(list.files("www/phylopic/"),".png",""),]

for (species in list_species$species){ print(species)
  taxon = taxonomy[taxonomy$species %in% species,]
  
  found=F
  for (taxa in rev(taxon$name)){
    if (found == F){
      img <- try(pick_phylopic(name = taxa, n = 1))
      if(inherits(img, "try-error"))  {
        #error handling code, maybe just skip this iteration using
        next
      } else {
        save_phylopic(img,paste("www/phylopic/",species,".png",sep=""))
        img = load.image(paste("www/phylopic/",species,".png",sep=""))
        thmb <- resize(img,2*162,2*162)
        save.image(thmb,paste("www/phylopic/",species,".png",sep=""))
        found=T
      }
    }
  }
}
