"""
Metro stations data for Madrid and Barcelona.
This module provides dictionaries mapping metro lines to their stations.
"""

madrid_metro_stations = {
    "Line 1": [
        "Pinar de Chamartín ④⑩", "Bambú", "Chamartín ⑩", "Plaza de Castilla ⑩⑨", "Valdeacederas",
        "Tetuán", "Estrecho", "Alvarado", "Cuatro Caminos ②⑥", "Ríos Rosas", "Iglesia",
        "Bilbao ④", "Tribunal ⑩", "Gran Vía ⑤", "Sol ②③", "Tirso de Molina", "Antón Martín",
        "Estación del Arte", "Atocha", "Menéndez Pelayo", "Pacífico ⑥", "Puente de Vallecas",
        "Nueva Numancia", "Portazgo", "Buenos Aires", "Alto del Arenal", "Miguel Hernández",
        "Sierra de Guadalupe", "Villa de Vallecas", "Congosto", "La Gavia", "Las Suertes",
        "Valdecarros"
    ],
    "Line 2": [
        "Las Rosas", "Avenida de Guadalajara", "Alsacia", "La Almudena", "La Elipa",
        "Ventas ⑤", "Manuel Becerra ⑥", "Goya ④", "Príncipe de Vergara ⑨", "Retiro",
        "Banco de España", "Sevilla", "Sol ①③", "Ópera ⑤", "Santo Domingo",
        "Noviciado", "San Bernardo ④", "Quevedo", "Canal ⑦", "Cuatro Caminos ①⑥"
    ],
    "Line 3": [
        "Villaverde Alto", "San Cristóbal", "Villaverde Bajo-Cruce", "Ciudad de los Ángeles",
        "San Fermín-Orcasitas", "Hospital 12 de Octubre", "Almendrales", "Legazpi",
        "Delicias", "Palos de la Frontera", "Embajadores", "Lavapiés", "Sol ①②",
        "Callao ⑤", "Plaza de España ⑩", "Ventura Rodríguez", "Argüelles", "Moncloa ⑥"
    ],
    "Line 4": [
        "Argüelles", "San Bernardo ②", "Bilbao ①", "Alonso Martínez ⑤⑩", "Colón",
        "Serrano", "Velázquez", "Goya ②", "Lista", "Diego de León ⑤⑥", "Avenida de América ⑥⑨",
        "Prosperidad", "Alfonso XIII", "Avenida de la Paz", "Arturo Soria",
        "Esperanza", "Canillas", "Mar de Cristal ⑧", "San Lorenzo", "Parque de Santa María",
        "Hortaleza", "Manoteras", "Pinar de Chamartín ①⑩"
    ],
    "Line 5": [
        "Alameda de Osuna", "El Capricho", "Canillejas", "Torre Arias", "Suanzes",
        "Ciudad Lineal", "Pueblo Nuevo ⑦", "Quintana", "El Carmen", "Ventas ②",
        "Diego de León ④⑥", "Núñez de Balboa ⑨", "Rubén Darío", "Chueca", "Gran Vía ①",
        "Callao ③", "Ópera ②", "La Latina", "Puerta de Toledo", "Acacias", "Pirámides",
        "Marqués de Vadillo", "Urgel", "Oporto ⑥", "Vista Alegre", "Carabanchel",
        "Eugenia de Montijo", "Aluche", "Empalme", "Campamento", "Casa de Campo ⑩"
    ],
    "Line 6": [
        "Nuevos Ministerios ⑧⑩", "Cuatro Caminos ①②", "Guzmán el Bueno ⑦",
        "Vicente Aleixandre", "Ciudad Universitaria", "Moncloa ③", "Argüelles",
        "Príncipe Pío ⑩", "Puerta del Ángel", "Alto de Extremadura", "Lucero",
        "Laguna", "Carpetana", "Oporto ⑤", "Opañel", "Plaza Elíptica ⑪", "Usera",
        "Legazpi", "Arganzuela-Planetario", "Méndez Álvaro", "Pacífico ①",
        "Conde de Casal", "Sainz de Baranda ⑨", "O'Donnell", "Manuel Becerra ②",
        "Diego de León ④⑤", "Avenida de América ④⑨", "República Argentina"
    ],
    "Line 7": [
        "Hospital del Henares", "Henares", "San Fernando", "Jarama", "Coslada Central",
        "La Rambla", "San Fernando", "Barrio del Puerto", "Estadio Metropolitano",
        "Las Musas", "San Blas", "Simancas", "García Noblejas", "Ascao",
        "Pueblo Nuevo ⑤", "Barrio de la Concepción", "Parque de las Avenidas",
        "Cartagena", "Avenida de América ④⑥⑨", "Gregorio Marañón ⑩", "Alonso Cano",
        "Canal ②", "Islas Filipinas", "Guzmán el Bueno ", "Francos Rodríguez",
        "Valdezarza", "Antonio Machado", "Peñagrande", "Avenida de la Ilustración",
        "Lacoma", "Pitis"
    ],
    "Line 8": [
        "Nuevos Ministerios ⑥⑩", "Colombia ⑨", "Pinar del Rey", "Mar de Cristal ④",
        "Campo de las Naciones", "Aeropuerto T1-T2-T3 ✈", "Aeropuerto T4 ✈"
    ],
    "Line 9": [
        "Paco de Lucía", "Mirasierra", "Herrera Oria", "Barrio del Pilar",
        "Plaza de Castilla ①⑩", "Duque de Pastrana", "Pío XII", "Colombia ⑧",
        "Concha Espina", "Cruz del Rayo", "Avenida de América ④⑥⑦", "Núñez de Balboa ⑤⑨",
        "Príncipe de Vergara ②", "Ibiza", "Sainz de Baranda ⑥", "Estrella",
        "Vinateros", "Artilleros", "Pavones", "Valdebernardo", "Vicálvaro",
        "San Cipriano", "Puerta de Arganda", "Rivas Urbanizaciones",
        "Rivas Vaciamadrid", "La Poveda", "Arganda del Rey"
    ],
    "Line 10": [
        "Hospital Infanta Sofía", "Reyes Católicos", "Baunatal", "Manuel de Falla",
        "Marqués de la Valdavia", "La Moraleja", "La Granja", "Ronda de la Comunicación",
        "Las Tablas", "Montecarmelo", "Tres Olivos", "Fuencarral", "Begoña",
        "Chamartín ①", "Plaza de Castilla ①⑨", "Cuzco", "Santiago Bernabéu",
        "Nuevos Ministerios ⑥⑧", "Gregorio Marañón ⑦", "Alonso Martínez ④⑤", "Tribunal ①",
        "Plaza de España ③", "Príncipe Pío ⑥", "Casa de Campo ⑤"
    ],
    "Line 11": [
        "Plaza Elíptica ⑥", "Abrantes", "Pan Bendito", "San Francisco",
        "Carabanchel Alto", "La Peseta", "La Fortuna"
    ],
    "Line 12": [
        "El Casar", "Juan de la Cierva", "San Nicasio", "Leganés Central",
        "Casa del Reloj", "Julián Besteiro", "Hospital Severo Ochoa", "Puerta del Sur ⑩",
        "Parque Lisboa", "Alcorcón Central", "Parque Oeste", "Universidad Rey Juan Carlos",
        "Móstoles Central", "Pradillo", "Hospital de Móstoles", "Manuela Malasaña",
        "Loranca", "Hospital de Fuenlabrada", "Parque Europa", "Fuenlabrada Central",
        "Parque de los Estados"
    ]
}

barcelona_metro_stations = {
    "Line 1": [
        "Hospital de Bellvitge", "Bellvitge", "Av. Carrilet", "Rambla Just Oliveras", 
        "Can Serra", "Florida", "Torrassa ⑨⑩", "Santa Eulàlia", "Mercat Nou", "Plaça de Sants ⑤", 
        "Hostafrancs", "Espanya ③⑧", "Rocafort", "Urgell", "Universitat ②", "Catalunya ③⑥⑦", 
        "Urquinaona ④", "Arc de Triomf", "Marina", "Glòries", "Clot ②", "Navas", 
        "La Sagrera ⑤⑨⑩", "Fabra i Puig", "Sant Andreu", "Torras i Bages", "Trinitat Vella", 
        "Baró de Viver", "Santa Coloma", "Fondo ⑨"
    ],
    "Line 2": [
        "Paral·lel ③", "Sant Antoni", "Universitat ①", "Passeig de Gràcia ③④", "Tetuan", 
        "Monumental", "Sagrada Família", "Encants", "Clot ①", "Bac de Roda", 
        "Sant Martí", "La Pau ④", "Verneda", "Artigues-Sant Adrià", "Sant Roc", 
        "Gorg ⑩", "Pep Ventura", "Badalona Pompeu Fabra"
    ],
    "Line 3": [
        "Zona Universitària ⑨⑩", "Palau Reial", "Maria Cristina", "Les Corts", 
        "Plaça del Centre", "Sants Estació ⑤Ⓡ", "Tarragona", "Espanya ①⑧", "Poble Sec", 
        "Paral·lel ②⑪", "Drassanes", "Liceu", "Catalunya ①⑥⑦", "Passeig de Gràcia ②④", 
        "Diagonal ⑤", "Fontana", "Lesseps", "Vallcarca", "Penitents", "Vall d'Hebron ④", 
        "Montbau", "Mundet", "Valldaura", "Canyelles", "Roquetes", "Trinitat Nova ④⑪"
    ],
    "Line 4": [
        "Trinitat Nova ③⑪", "Via Júlia", "Llucmajor", "Guinardó-Hospital de Sant Pau", 
        "Alfons X", "Joanic", "Verdaguer", "Girona", "Passeig de Gràcia ②③Ⓡ", 
        "Urquinaona ①", "Jaume I", "Barceloneta", "Ciutadella-Vila Olímpica", 
        "Bogatell", "Llacuna", "Poblenou", "Selva de Mar", "El Maresme-Fòrum", 
        "Besòs Mar", "Besòs", "La Pau ②"
    ],
    "Line 5": [
        "Cornellà Centre", "Gavarra", "Sant Ildefons", "Can Boixeres", "Can Vidalet", 
        "Pubilla Cases", "Collblanc ⑨⑩", "Badal", "Plaça de Sants ①", "Sants Estació ③", 
        "Entença", "Hospital Clínic", "Diagonal ③", "Verdaguer", "Sagrada Família", 
        "Sant Pau-Dos de Maig", "Camp de l'Arpa", "La Sagrera ①⑨⑩", "Congrés", 
        "Maragall", "Virrei Amat", "Vilapicina", "Horta", "El Carmel", "El Coll-La Teixonera", 
        "Vall d'Hebron ③④"
    ],
    "Line 6": [
        "Catalunya ①③⑦", "Provença", "Gràcia ⑦", "Sant Gervasi", "Muntaner", "La Bonanova", 
        "Les Tres Torres", "Sarrià", "Reina Elisenda"
    ],
    "Line 7": [
        "Catalunya ①③⑥", "Provença", "Gràcia ⑥", "Plaça Molina", "Pàdua", "El Putxet", 
        "Avinguda Tibidabo"
    ],
    "Line 8": [
        "Espanya ①③", "Magòria-La Campana", "Ildefons Cerdà", "Europa-Fira", 
        "Gornal", "Sant Josep", "L'Hospitalet-Av. Carrilet", "Almeda", 
        "Cornellà-Riera", "Sant Boi", "Molí Nou-Ciutat Cooperativa"
    ],
    "Line 9 Nord": [
        "La Sagrera ①⑤⑩", "Onze de Setembre", "Bon Pastor", "Can Peixauet", 
        "Santa Rosa", "Fondo ①", "Can Zam"
    ],
    "Line 9 Sud": [
        "Aeroport T1 ✈", "Aeroport T2 ✈", "Mas Blau", "Parc Nou", "Cèntric", 
        "El Prat Estació", "Les Moreres", "Mercabarna", "Parc Logístic", 
        "Fira", "Europa-Fira", "Torrassa ⑥", "Collblanc ⑤⑩", "Zona Universitària ③⑩"
    ],
    "Line 10 Nord": [
        "La Sagrera ①⑤⑨", "Onze de Setembre", "Bon Pastor", "Llefià", "La Salut", 
        "Gorg ②"
    ],
    "Line 10 Sud": [
        "Collblanc ⑤⑨", "Torrassa ①⑥", "Foneria", "Foc", "Zona Franca", "Port Comercial-La Factoria",
        "Ecoparc", "ZAL-Riu Vell", "Polígon Pratenc"
    ],
    "Line 11": [
        "Trinitat Nova ③④", "Casa de l'Aigua", "Torre Baró-Vallbona", "Ciutat Meridiana", 
        "Can Cuiàs"
    ]
} 