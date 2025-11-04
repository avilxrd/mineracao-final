# configurar de acordo com o pc de vcs
setwd("~/mineracao-final/data")

df_exames = read.csv("exame.csv")
df_prescricoes = read.csv("prescription.csv")

# remove a coluna unit e coloca o conteúdo no nome do exame
df_exames[, 4] <- ifelse(
  !is.na(df_exames[, 7]) & df_exames[, 7] != "",
  paste0(df_exames[, 4], " (", df_exames[, 7], ")"),
  df_exames[, 4]
)

df_exames <- df_exames[, -7]

# troca os s por 1 na coluna do pharmacy_assessment
df_prescricoes[, 9] <- gsub("s", "1", df_prescricoes[, 9], ignore.case = FALSE)

# remove a coluna ambulatory e allergy (todos os elementos iguais)
df_prescricoes <- df_prescricoes[, -8]
df_prescricoes <- df_prescricoes[, -9]


# remove as colunas cirurgica, obstetrica e emergencia, para criar uma nova baseada nelas
df_prescricoes$New_Column <- ifelse(
  df_prescricoes$Surgical == 1, 1,
  ifelse(df_prescricoes$Obstetrics == 1, 2,
         ifelse(df_prescricoes$Emergency == 1, 3, 0)
  )
)

df_prescricoes <- df_prescricoes[, !(names(df_prescricoes) %in% c("Surgical", "Obstetrics", "Emergency"))]
df_prescricoes <- df_prescricoes[, c(1:4, ncol(df_prescricoes), 5:(ncol(df_prescricoes)-1))]

# remove a coluna interventions (apenas NAs)
df_prescricoes$Interventions = NULL

# separa em subconjuntos por hospital_id
# cria um vetor de dataframes
hospitais <- split(df_exames, df_exames$Hospital_ID)

write.csv(df_exames, "df_exames.csv")
write.csv(df_prescricoes, "df_prescricoes.csv")