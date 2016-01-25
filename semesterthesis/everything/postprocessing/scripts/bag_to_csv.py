#!/usr/bin/env python
# Software License Agreement (BSD License)
#
# Copyright (c) 2008, Willow Garage, Inc.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
#  * Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#  * Redistributions in binary form must reproduce the above
#    copyright notice, this list of conditions and the following
#    disclaimer in the documentation and/or other materials provided
#    with the distribution.
#  * Neither the name of Willow Garage, Inc. nor the names of its
#    contributors may be used to endorse or promote products derived
#    from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
# Revision $1.0.0$

## script to convert bag file into csv file for postprocessing
#
# original version by Nick Speal, May 2013, at McGill University's 
# Aerospace Mechatronics Laboratory www.speal.ca
# adapted by Julian Surber, Oktober 2015, at ETH Zurich


import rosbag, sys, csv
import time
import string
import os #for file management make directory
import shutil #for file management, copy file

listOfBagFiles = []
#verify correct input arguments: 1 or 2
if (len(sys.argv) > 2):
	print "invalid number of arguments:   " + str(len(sys.argv))
	print "should be 2: 'bag2csv.py' and 'bagName'"
	print "or just 1  : 'bag2csv.py'"
	sys.exit(1)
elif (len(sys.argv) == 2):
	f = sys.argv[1]
	listOfBagFiles = [f]
	numberOfFiles = str(1)
	print "reading only 1 bagfile: " + str(listOfBagFiles[0])
elif (len(sys.argv) == 1):
	listOfBagFiles = [f for f in os.listdir(".") if f[-4:] == ".bag"]	#get list of only bag files in current dir.
	numberOfFiles = str(len(listOfBagFiles))
	print "reading all " + numberOfFiles + " bagfiles in current directory: \n"
	for f in listOfBagFiles:
		print f
	print "\n press ctrl+c in the next 10 seconds to cancel \n"
	time.sleep(10)
else:
	print "bad argument(s): " + str(sys.argv)	#shouldnt really come up
	sys.exit(1)

count = 0
for bagFile in listOfBagFiles:
	count += 1
	print "reading file " + str(count) + " of  " + numberOfFiles + ": " + bagFile
	#access bag
	bag = rosbag.Bag(bagFile)
	bagContents = bag.read_messages()
	bagName = bag.filename
	print str(bagName)

	#create a new directory
	folder = string.rstrip(bagName, "bag")
	folder = string.rstrip(folder,".")
	print str(folder)
	try:	#else already exists
		os.makedirs(folder)
	except:
		pass


	#get list of topics from the bag
	listOfTopics = []
	for topic, msg, t in bagContents:
		if topic not in listOfTopics:
			listOfTopics.append(topic)


	for topicName in listOfTopics:
		#Create a new CSV file for each topic
		filename = folder + '/' + string.replace(topicName, '/', '_') + '.csv'
		if filename.find("vicon") != -1:
			filename = folder + '/' + 'vicon.csv'

		print str(filename)
		with open(filename, 'w+') as csvfile:
			filewriter = csv.writer(csvfile, delimiter = ',')
			

			# assume topic contains estimated or ground truth pose --> write pose in the form (time tx ty tz qx qy qz qw)
			for subtopic, msg, t in bag.read_messages(topicName):	# for each instant in time that has data for topicName
				#parse data from this instant, which is of the form of multiple lines of "Name: value\n"
				#	- put it in the form of a list of 2-element lists
				msgString = str(msg)
				msgList = string.split(msgString, '\n')
				instantaneousListOfData = []
				string_to_find = "xyzw"
				for nameValuePair in msgList:
					splitPair = string.split(nameValuePair, ':')
					for i in range(len(splitPair)):	#should be 0 to 1
						splitPair[i] = string.strip(splitPair[i])
					instantaneousListOfData.append(splitPair)
				# write the value from each pair to the file
				t = 0.000001* float(str(t))
				values = [str(t)]	#first column will have rosbag timestamp [s]
				for pair in instantaneousListOfData:
					if string_to_find.find(pair[0]) != -1:
						values.append(pair[1])
				filewriter.writerow(values)
	bag.close()
print "Done reading all " + numberOfFiles + " bag files."